export interface Env {
}

const corsHeaders = {
	"Access-Control-Allow-Origin": "*",
	"Access-Control-Allow-Methods": "GET,HEAD,OPTIONS",
	"Access-Control-Max-Age": "86400",
};

// maxresdefault (1280), sddefault (640), hqdefault (480), mqdefault (320), default (120)
const checkYtUrl: RegExp = /(?:https?:\/\/|\/\/)?(?:www\.|m\.|.+\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|shorts\/|live\/|feeds\/api\/videos\/|watch\?v=|watch\?.+&v=))([\w-]{11})(?![\w-])(?:.*)/;
const checkYtId: RegExp = /[\w-]{11}/;

function objectNotFound(): Response {
	return new Response(`object not found`, {
		status: 404,
		headers: corsHeaders
	});
}

function handleOptions(request: Request): Response {
	if (request.headers.get('Origin') !== null &&
		request.headers.get('Access-Control-Request-Method') !== null &&
		request.headers.get('Access-Control-Request-Headers') !== null) {
		return new Response(null, {
			headers: {
				...corsHeaders,
				"Access-Control-Allow-Headers": request.headers.get(
					"Access-Control-Request-Headers"
				)!,
			},
		})
	} else {
		return new Response(null, {
			headers: {
				...corsHeaders,
				Allow: "GET, HEAD, OPTIONS",
			},
		})
	}
}

export default {
	async fetch(request: Request): Promise<Response> {
		const url = new URL(request.url);

		if (request.method === 'OPTIONS') {
			return handleOptions(request)
		}

		const searchParams = url.searchParams;
		if (searchParams === null || !searchParams.toString()) {
			return objectNotFound();
		}

		const ytId = searchParams.get('q');
		if (!ytId || !checkYtId.test(ytId)) {
			return objectNotFound();
		}

		console.log(`youtubeId: ${ytId}`);

		const iframe = `<!DOCTYPE html>
		<html>
		  <head>
		    <meta charset="UTF-8"> 
		    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
		    <title>Youtube Video</title> 
		  </head>
  		  <body>
			<iframe style="position:absolute; top:0; left:0; width:100%; height:100%;" src="https://www.youtube.com/embed/${ytId}?rel=0&controls=1&autoplay=1" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; fullscreen"></iframe>
  		  </body>
		</html>`

		return new Response(iframe, { headers: { "content-type": "text/html;charset=UTF-8", ...corsHeaders, } });
	},
}
