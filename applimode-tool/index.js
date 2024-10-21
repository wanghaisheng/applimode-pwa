/// internal v1
/// applimode 프로젝트 내부로 이동

const fs = require('fs').promises;
const path = require('path');
const readline = require('readline').createInterface({
  input: process.stdin,
  output: process.stdout,
});

const check_eng = /^[a-zA-Z]*$/;
const check_projectName = /^[a-zA-Z_\- ]*$/;
const check_firebaseProjectId = /^[a-zA-Z0-9\-]*$/;
const check_version = /([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)/;
const check_spc = /[~!@#$%^&*()_+|<>?:{}]/;
const check_hex_color = /^#?([a-f0-9]{6})$/i;
const check_password = /^(?=.*[a-zA-Z])[A-Za-z\d!@#$%^&*()_+]{4,}$/;

// custom_settings 파일에서 값을 찾기 위한 regex
const fullNameInCsRegex = /fullAppName = '(.*)';/
const shortNameInCsRegex = /shortAppName = '(.*)';/
const androidBundleIdInCsRegex = /androidBundleId = '(.*)';/
const appleBundleIdInCsRegex = /appleBundleId = '(.*)';/
const mainColorInCsRegex = /spareMainColor = '(.*)';/
const useFcmMessageRegex = /const bool useFcmMessage = (.*);/;
const useApnsRegex = /const bool useApns = (.*);/;
const fcmVapidKeyRegex = /const String fcmVapidKey = (.*);/;
const firebaseIdInCsRegex = /const String firebaseProjectId = '(.*)';/

// 색상 코드 (예시)
const bold = '\x1b[1m'; // 볼드
const underline = '\x1b[4m'; // 밑줄
const red = '\x1b[31m'; // 빨간색
const green = '\x1b[32m'; // 초록색
const yellow = '\x1b[33m'; // 노랑색
const blue = '\x1b[34m'; // 파랑
const redBold = '\x1b[31m\x1b[1m'; // 굵은빨간색
const greenBold = '\x1b[32m\x1b[1m'; // 굵은초록색
const yellowBold = '\x1b[33m\x1b[1m'; // 굵은노랑색
const blueBold = '\x1b[34m\x1b[1m'; // 굵은파랑

const reset = '\x1b[0m'; // 기본 색상으로 초기화

// applimode 프로젝트 내에 있기 때문에, 단독으로 쓸일 경우 ./../
const projectsPath = './../..';

const currentProjectPath = './..';
const currentLibPath = `${currentProjectPath}/lib`;

class Settings {
  constructor(comment, key, value) {
    this.comment = comment;
    this.key = key;
    this.value = value;
  }
}

function ask(question) {
  return new Promise(resolve => {
    readline.question(question, answer => {
      resolve(answer);
    });
  });
}

async function askRequired(question, validator, invalidMessage) {
  let answer;
  do {
    answer = await ask(question);
    if (!validator(answer)) {
      console.log(invalidMessage);
    }
  } while (!validator(answer));
  return answer;
}

function isEmpty(value) {
  if (value == "" || value == null || value == undefined || value.trim() == "") {
    return true;
  } else {
    return false;
  }
}

async function checkDirectoryExists(directoryPath) {
  try {
    await fs.access(directoryPath, fs.constants.F_OK);
    return true;
  } catch (err) {
    return false;
  }
}

function overMax(value, max) {
  if (value.length > max) {
    return false;
  } else {
    return true;
  }
}

// Function to replace phrase in a file
async function replacePhrase(filePath, oldPhrase, newPhrase) {
  try {
    const data = await fs.readFile(filePath, 'utf8');
    const newData = data.replace(new RegExp(oldPhrase, 'g'), newPhrase);
    if (data !== newData) {
      await fs.writeFile(filePath, newData, 'utf8');
      console.log(`Replaced "${blue}${oldPhrase}${reset}" with "${blue}${newPhrase}${reset}" in ${blue}${filePath}${reset}`);
    }
  } catch (err) {
    console.error(`${red}Error processing ${filePath}: ${err.message}${reset}`);
  }
}

// Function to process a directory
async function processDirectory(folderPath, oldPhrase, newPhrase) {
  const files = await fs.readdir(folderPath);

  for (const file of files) {
    const filePath = path.join(folderPath, file);
    const stats = await fs.stat(filePath);
    const extname = path.extname(file);

    // Skip media files
    if (['.jpg', '.jpeg', '.png', '.gif', '.mp3', '.mp4', '.svg', '.webp', '.apng', 'ico'].includes(extname.toLowerCase())) {
      // console.log(`is Media: ${filePath}`);
      continue;
    }

    if (file.startsWith('applimode-tool')) {
      console.log(`${blue}Skipping "applimode-tool" folder: ${filePath}${reset}`);
      continue;
    }


    if (stats.isDirectory()) {
      await processDirectory(filePath, oldPhrase, newPhrase)
    } else if (stats.isFile()) {
      await replacePhrase(filePath, oldPhrase, newPhrase);
    }
  }
}


function getSettingsList(settingsFile) {
  const settingsRawList = settingsFile.replace(new RegExp('import \'package:(.*);', 'g'), '').split(';');
  let settingsList = [];
  for (let i = 0; i < settingsRawList.length; i++) {
    const componants = settingsRawList[i].split(/const|=/);
    const comment = componants[0] == undefined ? '' : componants[0].trim();
    const key = componants[1] == undefined ? '' : componants[1].trim();
    const value = componants[2] == undefined ? '' : componants[2].trim();
    if (key !== '' && value !== '') {
      settingsList.push(new Settings(comment, key, value));
    }

  }
  return settingsList;
}

function getNewCumtomSettingsStr(importsList, newCustomSettingsList, userCustomSettingsList) {
  let newUserCustomSettingsStr = '';

  for (let i = 0; i < importsList.length; i++) {
    newUserCustomSettingsStr += `${importsList[i]}\n`
  }

  for (let i = 0; i < newCustomSettingsList.length; i++) {
    for (let k = 0; k < userCustomSettingsList.length; k++) {
      if (newCustomSettingsList[i].key == userCustomSettingsList[k].key) {
        newUserCustomSettingsStr += `\n\n${userCustomSettingsList[k].comment}\nconst ${userCustomSettingsList[k].key} = ${userCustomSettingsList[k].value};`
        break;
      }

      if (k == userCustomSettingsList.length - 1 && newCustomSettingsList[i].key !== userCustomSettingsList[k].key) {
        newUserCustomSettingsStr += `\n\n${newCustomSettingsList[i].comment}\nconst ${newCustomSettingsList[i].key} = ${newCustomSettingsList[i].value};`
        break;
      }
    }
  }

  newUserCustomSettingsStr = newUserCustomSettingsStr.replace(new RegExp('\n\n\n', 'g'), '\n\n');

  return newUserCustomSettingsStr;
}

async function copyFiles(sourceDir, destinationDir) {
  try {
    const files = await fs.readdir(sourceDir);

    for (const file of files) {
      const sourceFile = path.join(sourceDir, file);
      const destinationFile = path.join(destinationDir, file);

      await fs.copyFile(sourceFile, destinationFile);
      console.log(`copied ${blue}${file}${reset} to ${blue}${destinationDir}${reset}`);
    }
  } catch (err) {
    console.error(`${red}Error moving files: ${err}${reset}`);
  }
}

// Function to parse command line arguments
function parseArgs(args) {
  const options = {};
  // like --key=value
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    const [key, value] = arg.split('=');
    if (key.startsWith('--')) {
      options[key.slice(2)] = value;
    } else {
      options[key.slice(1)] = value;
    }
  }
  // like -key value
  /*
  let currentOption = null;
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg.startsWith('-')) {
      currentOption = arg.slice(1);
      options[currentOption] = '';
    } else if (currentOption !== null) {
      options[currentOption] = arg;
      currentOption = null;
    }
  }
  */
  return options;
}

async function getAmMainDirectoryName() {
  const isAmMainDirectory = await checkDirectoryExists(`${projectsPath}/applimode-main`);
  if (isAmMainDirectory) {
    return 'applimode-main';
  } else {
    return 'applimode';
  }
}

function getVersionMatch(pubspecFile) {
  const pubspecLines = pubspecFile.split('\n');
  for (let line of pubspecLines) {
    if (line.startsWith('version:')) {
      return line.match(check_version);
    }
  }
  return '0.0.0+0'.match(check_version);
}

async function isLatestVersion(newPubspecPath, userPubspecPath) {
  const newPubspecFile = await fs.readFile(newPubspecPath, 'utf8');
  const userPubspecFile = await fs.readFile(userPubspecPath, 'utf8');

  const newMatch = getVersionMatch(newPubspecFile);
  const userMatch = getVersionMatch(userPubspecFile);

  const [newVersion, newMajor, newMinor, newPatch, newBuild] = [newMatch[0], parseInt(newMatch[1]), parseInt(newMatch[2]), parseInt(newMatch[3]), parseInt(newMatch[4])];
  const [userVersion, userMajor, userMinor, userPatch, userBuild] = [userMatch[0], parseInt(userMatch[1]), parseInt(userMatch[2]), parseInt(userMatch[3]), parseInt(userMatch[4])];

  console.log(`newVersion: ${blue}${newVersion}${reset}`);
  console.log(`userVersion: ${blue}${userVersion}${reset}`);

  if (!(newMajor > userMajor || newMajor == userMajor && newMinor > userMinor || newMajor == userMajor && newMinor == userMinor && newPatch > userPatch || newMajor == userMajor && newMinor == userMinor && newPatch == userPatch && newBuild > userBuild) || newVersion == '0.0.0+0' || userVersion == '0.0.0+0') {
    return true;
  } else {
    return false;
  }
}

// 파일안에서 특정 regex만 찾아내서 값을 출력하는 메서드
async function extractValueFromFile(filepath, filename, regex) {
  const filePath = path.join(filepath, filename);

  try {
    const data = await fs.readFile(filePath, 'utf8');
    const match = data.match(regex);

    if (match && match[1]) {
      console.log(`${blue}current value: ${match[1]}${reset}`);
      return match[1];
    } else {
      console.error(`${red}${regex} not found in ${filename}${reset}`);
      return null;
    }
  } catch (err) {
    console.error(`${red}Error reading or processing ${filePath}: ${err.message}${reset}`);
    return null;
  }
}

function removeQuotes(str) {
  if (str.startsWith('"') && str.endsWith('"') || str.startsWith("'") && str.endsWith("'")) {
    return str.slice(1, -1);
  } else {
    return str;
  }
}

// Get command-line arguments
const command = process.argv.slice(2, 3);
const args = process.argv.slice(3); // Skip first two arguments (node and script filename)

// Parse arguments
const options = parseArgs(args);

// define defalut names
const amAndBundleId = 'applimode.my_applimode';
const amIosBundleId = 'applimode.myApplimode'
const amUniName = 'my_applimode';
const amCamelName = 'myApplimode';
const amFullName = 'My Applimode';
const amShortName = 'AMB';
const amFbName = 'my-applimode';
const amOrgnizationName = 'applimode';
const amWorkerKey = 'yourWorkerKey';
const amMainColor = 'FCB126';

// Extract arguments or use default values if not provided
const oUserProjectName = options['project-name'] || options['p'];
const oUserFullName = options['full-name'] || options['f'];
const oUserShortName = options['short-name'] || options['s'] || oUserFullName;
const oUserOrganizationName = options['organization-name'] || options['o'];
// const oUserFirebaseName = options['firebase-name'] || options['b'];
const oUserProjectFolderName = options['directory-name'] || options['d'];
const oUserCloudflareWorkerKey = options['worker-key'] || options['w'];
const oUserMainColor = options['main-color'] || options['c'];

const customSettingsFile = 'custom_settings.dart';
const envFile = '.env';
const pubspecFile = 'pubspec.yaml';
const indexFile = 'index.html';
const fbMessageFile = 'firebase-messaging-sw.js';
const manifestFile = 'manifest.json';

// init applimode
async function initApplimode() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's get started.${reset}`);

  /// applimode 또는 applimode-main 디렉토리가 있는지 확인
  const amMainDirName = await getAmMainDirectoryName();
  const amMainRootPath = `${projectsPath}/${amMainDirName}`;
  const kotlinOrganizationPath = `${amMainRootPath}/android/app/src/main/kotlin/com`
  const kotlinAndBundleIdPath = `${amMainRootPath}/android/app/src/main/kotlin/com/applimode`

  // check the main directory exists
  const checkMainDirectory = await checkDirectoryExists(amMainRootPath);
  if (!checkMainDirectory) {
    console.log(`${red}The ${amMainDirName} directory does not exist.${reset}`);
    return;
  }

  let userProjectName = '';

  /// 프로젝트 이름을 파라미터로 받는 경우
  if (!isEmpty(oUserProjectName) && check_projectName.test(oUserProjectName)) {
    userProjectName = oUserProjectName
  } else {
    /// 프로젝트 이름 파라미터 없을 경우, 유저 입력
    userProjectName = await askRequired(
      `(1/4) ${greenBold}Enter your project name (letters only, required): ${reset}`,
      answer => !isEmpty(answer) && check_projectName.test(answer),
      `${red}Can only contain letters, spaces, and these characters: _ -${reset}`
    );
  }

  const splits = userProjectName.split(/ |_|-/);

  let underbarName = '';
  let camelName = '';
  let andBundleId = '';
  let iosBundleId = '';
  let appFullName = '';
  let appShortName = '';
  let appOrganizationName = '';

  for (let i = 0; i < splits.length; i++) {
    let word = splits[i].toLowerCase().trim();
    if (word.length === 0) {
      continue; // word의 길이가 0이면 다음 반복으로 넘어갑니다.
    }
    if (i == 0) {
      let firstChar = word.charAt(0);
      let others = word.slice(1);
      let firstUpperWord = firstChar.toUpperCase() + others;
      underbarName += word;
      camelName += word;
      appFullName += firstUpperWord;
      appShortName += firstUpperWord;
      appOrganizationName += word;
    } else {
      let firstChar = word.charAt(0);
      let others = word.slice(1);
      let firstUpperWord = firstChar.toUpperCase() + others;
      underbarName += `_${word}`;
      camelName += firstUpperWord;
      appFullName += ` ${firstUpperWord}`;
      appShortName += ` ${firstUpperWord}`;
      appOrganizationName += word;
    }
  }

  /// 앱 풀네임 파라미터로 받는 경우
  if (!isEmpty(oUserFullName)) {
    appFullName = oUserFullName;
  } else {
    /// 풀네임 파라미터 없을 경우, 유저 입력 및 기본값 설정
    const inputAppFullName = await ask(`(2/4) ${greenBold}Enter your full app name (default: ${appFullName}): ${reset}`);
    appFullName = isEmpty(inputAppFullName) ? appFullName : inputAppFullName;
  }

  /// 앱 숏네임 파라미터로 받는 경우
  if (!isEmpty(oUserShortName)) {
    appShortName = oUserShortName;
  } else {
    /// 숏네임 파라미터 없을 경우, 유저 입력 및 기본값 설정, 어디에서 사용되는지도 설명
    const inputAppShortName = await ask(`(3/4) ${greenBold}Enter your short app name (default: ${appShortName}): ${reset}`);
    appShortName = isEmpty(inputAppShortName) ? appShortName : inputAppShortName;
  }

  /// 조직이름 파라메터로 받는 경우
  if (!isEmpty(oUserOrganizationName) && check_eng.test(oUserOrganizationName)) {
    appOrganizationName = oUserOrganizationName.trim().toLowerCase();
  } else {
    /// 조직이름 파라미터 없을 경우, 유저 입력 및 기본값 설정
    const inputAppOrganizationName = await askRequired(
      `(4/4) ${greenBold}Enter your organization name (letters only, default: ${appOrganizationName}): ${reset}`,
      answer => check_eng.test(answer),
      `${red}Can only contain letters${reset}`
    );
    appOrganizationName = isEmpty(inputAppOrganizationName) ? appOrganizationName : inputAppOrganizationName.trim().toLowerCase();
  }


  andBundleId = `${appOrganizationName}.${underbarName}`;
  iosBundleId = `${appOrganizationName}.${camelName}`;

  await processDirectory(amMainRootPath, amAndBundleId, andBundleId);
  await processDirectory(amMainRootPath, amIosBundleId, iosBundleId);
  await processDirectory(amMainRootPath, amUniName, underbarName);
  await processDirectory(amMainRootPath, amCamelName, camelName);
  await processDirectory(amMainRootPath, amFullName, appFullName);
  await processDirectory(amMainRootPath, amShortName, appShortName);

  /// 파라미터로 워커키 전달할 경우
  if (!isEmpty(oUserCloudflareWorkerKey)) {
    await processDirectory(amMainRootPath, amWorkerKey, oUserCloudflareWorkerKey);
  }

  /// 파라미터로 메인컬러 전달할 경우
  if (!isEmpty(oUserMainColor)) {
    await processDirectory(amMainRootPath, amMainColor, oUserMainColor);
  }

  await fs.rename(path.join(kotlinAndBundleIdPath, amUniName), path.join(kotlinAndBundleIdPath, underbarName));
  await fs.rename(path.join(kotlinOrganizationPath, amOrgnizationName), path.join(kotlinOrganizationPath, appOrganizationName));
  await fs.rename(path.join(projectsPath, amMainDirName), path.join(projectsPath, underbarName));

  console.log(`${yellow}👋 Applimode initialization was successful.${reset}`);
}

// upgrade applimode
async function upgradeApplimode() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's get upgraded.${reset}`);

  const amMainDirName = await getAmMainDirectoryName();
  const amMainRootPath = `${projectsPath}/${amMainDirName}`;
  const amMainLibPath = `${amMainRootPath}/lib`
  const kotlinOrganizationPath = `${amMainRootPath}/android/app/src/main/kotlin/com`
  const kotlinAndBundleIdPath = `${amMainRootPath}/android/app/src/main/kotlin/com/applimode`

  // check the main directory exists
  const checkMainDirectory = await checkDirectoryExists(amMainRootPath);
  if (!checkMainDirectory) {
    console.log(`${red}The ${amMainDirName} directory does not exist.${reset}`);
    return;
  }

  let userProjectFolderName = '';

  /// 프로젝트 폴더 이름을 파라미터로 받는 경우
  if (!isEmpty(oUserProjectFolderName)) {
    userProjectFolderName = oUserProjectFolderName
  } else {
    /// 프로젝트 폴더 이름 파라미터 없을 경우, 유저 입력
    userProjectFolderName = await askRequired(
      `(1/1) ${greenBold}Enter your project folder name (required): ${reset}`,
      answer => !isEmpty(answer),
      `${red}Your project folder name is invalid.${reset}`
    );
  }

  const newRootPath = amMainRootPath;
  const userRootPath = `${projectsPath}/${userProjectFolderName}`;

  // check the project directory exists
  const checkProjectDirectory = await checkDirectoryExists(userRootPath);
  if (!checkProjectDirectory) {
    console.log(`${red}Your project directory does not exist.${reset}`);
    return;
  }

  const newLibPath = amMainLibPath;
  const userLibPath = `${userRootPath}/lib`;
  const newImagesPath = `${amMainRootPath}/assets/images`;
  const userImagesPath = `${userRootPath}/assets/images`;
  const newWebPath = `${amMainRootPath}/web`;
  const userWebPath = `${userRootPath}/web`;



  const newPubspecPath = path.join(newRootPath, pubspecFile);
  const userPubspecPath = path.join(userRootPath, pubspecFile);

  const isLatest = await isLatestVersion(newPubspecPath, userPubspecPath);

  if (isLatest) {
    console.log(`${yellow}👋 Your Applimode is up to date.${reset}`);
    return;
  }

  const newEnvPath = path.join(newRootPath, envFile);
  const userEnvPath = path.join(userRootPath, envFile);
  const newCustomSettingsPath = path.join(newLibPath, customSettingsFile);
  const userCustomSettingsPath = path.join(userLibPath, customSettingsFile);
  const newIndexPath = path.join(newWebPath, indexFile);
  const userIndexPath = path.join(userWebPath, indexFile);
  const newFbMessagePath = path.join(newWebPath, fbMessageFile);
  const userFbMessagePath = path.join(userWebPath, fbMessageFile);
  const newManifestPath = path.join(newWebPath, manifestFile);
  const userManifestPath = path.join(userWebPath, manifestFile);

  // const newEnvFile = await fs.readFile(newEnvPath, 'utf8');
  const userEnvFile = await fs.readFile(userEnvPath, 'utf8');
  const newCustomSettingsFile = await fs.readFile(newCustomSettingsPath, 'utf8');
  const userCustomSettingsFile = await fs.readFile(userCustomSettingsPath, 'utf8');
  const userIndexFile = await fs.readFile(userIndexPath, 'utf8');
  const userFbMessageFile = await fs.readFile(userFbMessagePath, 'utf8');
  const userManifestFile = await fs.readFile(userManifestPath, 'utf8');

  let fullAppName = '';
  let shortAppName = '';
  let underbarAppName = '';
  let camelAppName = '';
  let androidBundleId = '';
  let appleBundleId = '';
  let firebaseProjectName = '';
  let mainColor = '';

  const importsList = newCustomSettingsFile.match(new RegExp('import \'package:(.*);', 'g'));

  const newCustomSettingsList = getSettingsList(newCustomSettingsFile);
  const userCustomSettingsList = getSettingsList(userCustomSettingsFile);

  for (let i = 0; i < userCustomSettingsList.length; i++) {
    if (userCustomSettingsList[i].key == 'fullAppName') {
      fullAppName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'shortAppName') {
      shortAppName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'underbarAppName') {
      underbarAppName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'camelAppName') {
      camelAppName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'androidBundleId') {
      androidBundleId = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'appleBundleId') {
      appleBundleId = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'firebaseProjectName') {
      firebaseProjectName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'spareMainColor') {
      mainColor = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
  }

  const organizationName = androidBundleId.replace(`.${underbarAppName}`, '').trim();

  // change names in docs
  await processDirectory(amMainRootPath, amAndBundleId, androidBundleId);
  await processDirectory(amMainRootPath, amIosBundleId, appleBundleId);
  await processDirectory(amMainRootPath, amUniName, underbarAppName);
  await processDirectory(amMainRootPath, amCamelName, camelAppName);
  await processDirectory(amMainRootPath, amFullName, fullAppName);
  await processDirectory(amMainRootPath, amShortName, shortAppName);
  await processDirectory(amMainRootPath, amFbName, firebaseProjectName);
  await processDirectory(amMainRootPath, amMainColor, mainColor);

  // applimode-main/android/app/src/main/kotlin/com/applimode/my_applimode/MainActivity.kt
  await fs.rename(path.join(kotlinAndBundleIdPath, amUniName), path.join(kotlinAndBundleIdPath, underbarAppName));
  await fs.rename(path.join(kotlinOrganizationPath, amOrgnizationName), path.join(kotlinOrganizationPath, organizationName));

  // generate custom_settings file
  const newUserCustomSettingsStr = getNewCumtomSettingsStr(importsList, newCustomSettingsList, userCustomSettingsList);
  await fs.writeFile(newCustomSettingsPath, newUserCustomSettingsStr, 'utf8');

  // generate .env file
  await fs.writeFile(newEnvPath, userEnvFile, 'utf8');

  // copy user's index.html file
  await fs.writeFile(newIndexPath, userIndexFile, 'utf8');

  // copy user's firebase-messaging-sw.js file
  await fs.writeFile(newFbMessagePath, userFbMessageFile, 'utf8');

  // copy user's mainfest.json file
  await fs.writeFile(newManifestPath, userManifestFile, 'utf8');

  // move images
  await copyFiles(userImagesPath, newImagesPath);

  // rename directories name
  await fs.rename(path.join(projectsPath, userProjectFolderName), path.join(projectsPath, `${userProjectFolderName}_old`));
  await fs.rename(path.join(projectsPath, amMainDirName), path.join(projectsPath, userProjectFolderName));

  console.log(`${yellow}👋 Applimode upgrade was successful.${reset}`);
}

// set app full name
async function setAppFullName() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the app full name.${reset}`);

  let oldFullAppName = '';
  let newFullAppName = '';


  oldFullAppName = await extractValueFromFile(currentLibPath, customSettingsFile, fullNameInCsRegex);
  if (isEmpty(oldFullAppName)) {
    console.log(`${red}fullname not found.${reset}`);
    return;
  }

  const singleArg = args.join(' ');

  if (isEmpty(singleArg) || isEmpty(removeQuotes(singleArg))) {
    newFullAppName = await askRequired(
      `(1/1) ${greenBold}Enter a new full app name (required): ${reset}`,
      answer => !isEmpty(answer),
      `${red}Please enter a full app name that is at least 1 character long${reset}`
    );
  } else {
    newFullAppName = removeQuotes(singleArg).trim();
  }

  // console.log(`old: ${oldFullAppName}`);
  // console.log(`new: ${newFullAppName}`);

  await processDirectory(currentProjectPath, oldFullAppName, newFullAppName);

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

// set app short name
async function setAppShortName() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the app short name.${reset}`);

  let oldShortAppName = '';
  let newShortAppName = '';


  oldShortAppName = await extractValueFromFile(currentLibPath, customSettingsFile, shortNameInCsRegex);
  if (isEmpty(oldShortAppName)) {
    console.log(`${red}shortname not found.${reset}`);
    return;
  }

  const singleArg = args.join(' ');

  if (isEmpty(singleArg) || isEmpty(removeQuotes(singleArg))) {
    newShortAppName = await askRequired(
      `(1/1) ${greenBold}Enter a new short app name (required): ${reset}`,
      answer => !isEmpty(answer),
      `${red}Please enter a short app name that is at least 1 character long${reset}`
    );
  } else {
    newShortAppName = removeQuotes(singleArg).trim();
  }

  // console.log(`old: ${oldShortAppName}`);
  // console.log(`new: ${newShortAppName}`);

  await processDirectory(currentProjectPath, oldShortAppName, newShortAppName);

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

// set app organization name
async function setAppOrganizationName() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the app short name.${reset}`);

  let oldOrganizationName = '';
  let newOrganizationName = '';


  const androidBundleId = await extractValueFromFile(currentLibPath, customSettingsFile, androidBundleIdInCsRegex);
  const appleBundleId = await extractValueFromFile(currentLibPath, customSettingsFile, appleBundleIdInCsRegex);
  if (isEmpty(androidBundleId) || isEmpty(appleBundleId) || !androidBundleId.includes('.') || !appleBundleId.includes('.')) {
    console.log(`${red}organization not found.${reset}`);
    return;
  }

  oldOrganizationName = androidBundleId.split('.')[0];
  const androidUnderbarName = androidBundleId.split('.')[1];
  const appleCamelName = appleBundleId.split('.')[1];

  const singleArg = args.join(' ');

  if (isEmpty(singleArg) || isEmpty(removeQuotes(singleArg)) || !check_eng.test(singleArg)) {
    if (!check_eng.test(singleArg)) {
      console.log(`${red}Can only contain letters${reset}`);
    }
    newOrganizationName = await askRequired(
      `(1/1) ${greenBold}Enter a new organization name (required): ${reset}`,
      answer => !isEmpty(answer) && check_eng.test(answer),
      `${red}Can only contain letters${reset}`
    );
  } else {
    newOrganizationName = removeQuotes(singleArg).trim();
  }

  // console.log(`old: ${oldOrganizationName}`);
  // console.log(`new: ${newOrganizationName}`);

  const newAndroidBundleId = `${newOrganizationName}.${androidUnderbarName}`;
  const newAppleBundleId = `${newOrganizationName}.${appleCamelName}`;

  const kotlinOrganizationPath = `${currentProjectPath}/android/app/src/main/kotlin/com`

  await processDirectory(currentProjectPath, androidBundleId, newAndroidBundleId);
  await processDirectory(currentProjectPath, appleBundleId, newAppleBundleId);

  await fs.rename(path.join(kotlinOrganizationPath, oldOrganizationName), path.join(kotlinOrganizationPath, newOrganizationName));

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

async function generateFirebaserc() {
  try {
    const firebaseJson = JSON.parse(await fs.readFile(`${currentProjectPath}/firebase.json`, 'utf8'));

    // projectId 추출
    let projectId = firebaseJson.flutter?.platforms?.android?.default?.projectId;

    if (!projectId) {
      const firebaseOptionsContent = await fs.readFile(`${currentProjectPath}/lib/firebase_options.dart`, 'utf8');
      const regex = /projectId:\s*'([^']+)'/; // projectId 추출을 위한 정규 표현식
      const match = firebaseOptionsContent.match(regex);
      projectId = match ? match[1] : null;
    }

    // projectId를 찾지 못하면 오류 발생
    if (!projectId) {
      throw new Error(`${red}error: We can't find your Firebase project id. Run${reset} ${blueBold}firebase init firestore${reset}${red}, then type n to all questions.${reset}`);
    }

    // .firebaserc 파일 내용 생성
    const firebasercContent = {
      "projects": {
        "default": projectId
      }
    };

    // .firebaserc 파일 작성 (비동기)
    await fs.writeFile(`${currentProjectPath}/.firebaserc`, JSON.stringify(firebasercContent, null, 2) + '\n');
    // custom_settings.dart 의 firebaseProjectId 값 변경
    await replacePhraseInFile(
      `${currentLibPath}/${customSettingsFile}`,
      firebaseIdInCsRegex,
      `const String firebaseProjectId = '${projectId}';`
    );

    console.log(`${yellow}👋 .firebaserc file has been created.${reset}`);
  } catch (error) {
    console.error(`${red}error: We can't find your Firebase project id. Run${reset} ${blueBold}firebase init firestore${reset}${red}, then type n to all questions.${reset}`);
  }
}

// set app main color
async function setAppMainColor() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the app main color.${reset}`);

  let oldMainColor = '';
  let newMainColor = '';


  oldMainColor = await extractValueFromFile(currentLibPath, customSettingsFile, mainColorInCsRegex);
  if (isEmpty(oldMainColor)) {
    console.log(`${red}main color not found.${reset}`);
    return;
  }

  const singleArg = args.join(' ');

  if (isEmpty(singleArg) || isEmpty(removeQuotes(singleArg)) || !check_hex_color.test(removeQuotes(singleArg))) {
    if (!isEmpty(singleArg) && !check_hex_color.test(removeQuotes(singleArg))) {
      console.log(`${red}Please enter a valid 6-digit hexadecimal color code.${reset}`);
    }
    newMainColor = await askRequired(
      `(1/1) ${greenBold}Enter a main color for your app (required): ${reset}`,
      answer => check_hex_color.test(answer),
      `${red}Please enter a valid 6-digit hexadecimal color code.${reset}`
    );
  } else {
    newMainColor = removeQuotes(singleArg);
  }

  newMainColor = newMainColor.replace(/^#/, '');

  // console.log(`old: ${oldShortAppName}`);
  // console.log(`new: ${newShortAppName}`);

  await processDirectory(currentProjectPath, oldMainColor, newMainColor);

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

// set app main color
async function setWorkerKey() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the Worker key.${reset}`);

  let newWorkerKey = '';

  const singleArg = args.join(' ');

  if (isEmpty(singleArg) || isEmpty(removeQuotes(singleArg)) || !check_password.test(removeQuotes(singleArg))) {
    if (!isEmpty(singleArg) && !check_password.test(removeQuotes(singleArg))) {
      console.log(`${red}Please enter a password of at least 4 characters, including at least one letter.${reset}`);
    }
    newWorkerKey = await askRequired(
      `(1/1) ${greenBold}Enter a Worker key for your app (required): ${reset}`,
      answer => check_password.test(answer),
      `${red}Please enter a password of at least 4 characters, including at least one letter.${reset}`
    );
  } else {
    newWorkerKey = removeQuotes(singleArg);
  }

  const newWorkerKeyContent = `WORKER_KEY=${newWorkerKey}`;

  await fs.writeFile(`${currentProjectPath}/.env`, newWorkerKeyContent, 'utf8');

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

async function setFcm() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the Firebase Cloud Messaging.${reset}`);

  const useFcmForAndroid = await askRequired(
    `(1/3) ${greenBold}Enable FCM for Android? (y/n or yes/no): ${reset}`,
    answer => /^(y|yes|n|no)$/i.test(answer),
    `${red}Please enter y, yes, n, or no.${reset}`
  );

  const useFcmForIos = await askRequired(
    `(2/3) ${greenBold}Enable FCM for iOS (APNs)? (y/n or yes/no): ${reset}`,
    answer => /^(y|yes|n|no)$/i.test(answer),
    `${red}Please enter y, yes, n, or no.${reset}`
  );

  const useFcmForWeb = await askRequired(
    `(3/3) ${greenBold}Enable FCM for Web? (y/n or yes/no): ${reset}`,
    answer => /^(y|yes|n|no)$/i.test(answer),
    `${red}Please enter y, yes, n, or no.${reset}`
  );

  let vapidKey = '';
  if (/^(y|yes)$/i.test(useFcmForWeb)) {
    vapidKey = await askRequired( // askRequired 함수로 변경
      `(4/4) ${greenBold}Enter your VAPID key for Web (required, You can check your vapid here. Firebase Console > your project > Project settings > Cloud Messaging - Web Push certificates.): ${reset}`,
      answer => !isEmpty(answer),
      `${red}Please enter your VAPID key.${reset}`
    );
  }

  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    useFcmMessageRegex,
    `const bool useFcmMessage = ${/^(y|yes)$/i.test(useFcmForAndroid)};`
  );

  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    useApnsRegex,
    `const bool useApns = ${/^(y|yes)$/i.test(useFcmForIos)};`
  );

  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    fcmVapidKeyRegex,
    `const String fcmVapidKey = '${vapidKey}';`
  );


  // firebase_options.dart 파일에서 값 추출 및 firebase-messaging-sw.js, index.html에 입력
  if (/^(y|yes)$/i.test(useFcmForWeb)) {
    await updateFirebaseMessagingSw();
    await updateIndexHtml(true); // FCM for Web 활성화 시 index.html 수정
  } else {
    await updateIndexHtml(false); // FCM for Web 비활성화 시 index.html 수정
  }

  console.log(`${yellow}👋 Firebase Cloud Messaging settings have been updated.${reset}`);
}

// 파일에서 특정 regex를 찾아 newPhrase로 변경하는 함수
async function replacePhraseInFile(filePath, regex, newPhrase) {
  try {
    const data = await fs.readFile(filePath, 'utf8');
    const newData = data.replace(regex, newPhrase);
    await fs.writeFile(filePath, newData, 'utf8');
    console.log(`Updated ${blue}${filePath}${reset}`);
  } catch (err) {
    console.error(`${red}Error updating ${filePath}: ${err.message}${reset}`);
  }
}


async function updateFirebaseMessagingSw() {
  const firebaseOptionsPath = `${currentLibPath}/firebase_options.dart`;
  const firebaseMessagingSwPath = `${currentProjectPath}/web/firebase-messaging-sw.js`;

  try {
    const firebaseOptionsContent = await fs.readFile(firebaseOptionsPath, 'utf8');

    // web 옵션 부분 추출
    const webOptionsMatch = firebaseOptionsContent.match(/static const FirebaseOptions web = FirebaseOptions\(([\s\S]*?)\);/);
    if (!webOptionsMatch) {
      throw new Error(`${red}Error: Could not find FirebaseOptions for web in ${firebaseOptionsPath}${reset}`);
    }
    const webOptionsContent = webOptionsMatch[1];

    const apiKey = extractValueFromFirebaseOptions(webOptionsContent, /apiKey:\s*'([^']+)'/);
    const authDomain = extractValueFromFirebaseOptions(webOptionsContent, /authDomain:\s*'([^']+)'/);
    const projectId = extractValueFromFirebaseOptions(webOptionsContent, /projectId:\s*'([^']+)'/);
    const storageBucket = extractValueFromFirebaseOptions(webOptionsContent, /storageBucket:\s*'([^']+)'/);
    const messagingSenderId = extractValueFromFirebaseOptions(webOptionsContent, /messagingSenderId:\s*'([^']+)'/);
    const appId = extractValueFromFirebaseOptions(webOptionsContent, /appId:\s*'([^']+)'/);
    const measurementId = extractValueFromFirebaseOptions(webOptionsContent, /measurementId:\s*'([^']+)'/);

    let newContent = await fs.readFile(firebaseMessagingSwPath, 'utf8');

    // firebase.initializeApp 부분 찾기
    const appInitMatch = newContent.match(/firebase\.initializeApp\(\{([\s\S]*?)\}\);/);
    if (!appInitMatch) {
      throw new Error(`${red}Error: Could not find firebase.initializeApp in ${firebaseMessagingSwPath}${reset}`);
    }
    const appInitContent = appInitMatch[1];

    // 각 값을 새로운 값으로 치환
    let updatedAppInitContent = appInitContent
      .replace(/apiKey:\s*"[^"]*"/, `apiKey: "${apiKey}"`)
      .replace(/authDomain:\s*"[^"]*"/, `authDomain: "${authDomain}"`)
      .replace(/projectId:\s*"[^"]*"/, `projectId: "${projectId}"`)
      .replace(/storageBucket:\s*"[^"]*"/, `storageBucket: "${storageBucket}"`)
      .replace(/messagingSenderId:\s*"[^"]*"/, `messagingSenderId: "${messagingSenderId}"`)
      .replace(/appId:\s*"[^"]*"/, `appId: "${appId}"`)
      .replace(/measurementId:\s*"[^"]*"/, measurementId ? `measurementId: "${measurementId}"` : `// measurementId: "..."`); // measurementId가 없으면 주석 처리

    // 새로운 내용으로 파일 업데이트
    newContent = newContent.replace(appInitMatch[0], `firebase.initializeApp({\n${updatedAppInitContent}\n});`);

    await fs.writeFile(firebaseMessagingSwPath, newContent, 'utf8');
    console.log(`Updated ${blue}${firebaseMessagingSwPath}${reset}`);

  } catch (err) {
    console.error(`${red}Error updating ${firebaseMessagingSwPath}: ${err.message}${reset}`);
  }
}


function extractValueFromFirebaseOptions(content, regex) {
  const match = content.match(regex);
  return match ? match[1] : null;
}

async function updateIndexHtml(enableFcmForWeb) {
  const indexHtmlPath = `${currentProjectPath}/web/index.html`;

  try {
    let indexHtmlContent = await fs.readFile(indexHtmlPath, 'utf8');

    // flutter_bootstrap.js 부분 찾기
    const flutterBootstrapMatch = indexHtmlContent.match(/<!--flutter_bootstrap.js starts-->([\s\S]*?)<!--flutter_bootstrap.js ends-->/);
    if (!flutterBootstrapMatch) {
      throw new Error(`${red}Error: Could not find flutter_bootstrap.js section in ${indexHtmlPath}${reset}`);
    }

    let updatedFlutterBootstrapContent;

    if (enableFcmForWeb) {
      // FCM 활성화 시: 정해진 문구로 변경
      updatedFlutterBootstrapContent = `
  <!--
  <script src="flutter_bootstrap.js" async=""></script>
  -->
  <!--When using push notification for web app-->
  <script src="flutter_bootstrap.js" async="">
    if ('serviceWorker' in navigator) {
        // Service workers are supported. Use them.
        window.addEventListener('load', function () {
          // Register Firebase Messaging service worker.
          navigator.serviceWorker.register('firebase-messaging-sw.js', {
            scope: '/firebase-cloud-messaging-push-scope',
          });
        });
      }
  </script>
  `;
    } else {
      // FCM 비활성화 시: 정해진 문구로 변경
      updatedFlutterBootstrapContent = `
  <script src="flutter_bootstrap.js" async=""></script>
  <!--When using push notification for web app-->
  <!--
  <script src="flutter_bootstrap.js" async="">
    if ('serviceWorker' in navigator) {
        // Service workers are supported. Use them.
        window.addEventListener('load', function () {
          // Register Firebase Messaging service worker.
          navigator.serviceWorker.register('firebase-messaging-sw.js', {
            scope: '/firebase-cloud-messaging-push-scope',
          });
        });
      }
  </script>
  -->
  `;
    }

    // 새로운 내용으로 파일 업데이트
    indexHtmlContent = indexHtmlContent.replace(flutterBootstrapMatch[0], `<!--flutter_bootstrap.js starts-->${updatedFlutterBootstrapContent}<!--flutter_bootstrap.js ends-->`);

    await fs.writeFile(indexHtmlPath, indexHtmlContent, 'utf8');
    console.log(`Updated ${blue}${indexHtmlPath}${reset}`);
  } catch (err) {
    console.error(`${red}Error updating ${indexHtmlPath}: ${err.message}${reset}`);
  }
}

// Check if the folder exists
fs.access(projectsPath)
  .then(async () => {
    if (command[0].trim() == 'init') {
      await initApplimode();
    } else if (command[0].trim() == 'upgrade') {
      await upgradeApplimode();
    } else if (command[0].trim() == 'fullname') {
      await setAppFullName();
    } else if (command[0].trim() == 'shortname') {
      await setAppShortName();
    } else if (command[0].trim() == 'organization') {
      await setAppOrganizationName();
    } else if (command[0].trim() == 'firebaserc') {
      await generateFirebaserc();
    } else if (command[0].trim() == 'color') {
      await setAppMainColor();
    } else if (command[0].trim() == 'worker') {
      await setWorkerKey();
    } else if (command[0].trim() == 'fcm') {
      await setFcm();
    } else {
      console.error(`${red}Error:', 'The command must start with init or upgrade.${reset}`);
      process.exit(1);
    }
    readline.close();
  })
  .catch(err => {
    console.error(`${red}Error: ${err}${reset}`);
    process.exit(1);
  });
