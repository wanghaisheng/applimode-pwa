export interface Env {
}

const corsHeaders = {
	"Access-Control-Allow-Origin": "*",
	"Access-Control-Allow-Methods": "GET,HEAD,OPTIONS",
	"Access-Control-Max-Age": "86400",
};

// maxresdefault (1280), sddefault (640), hqdefault (480), mqdefault (320), default (120)
const checkYtTnUrl: RegExp = /https:\/\/img\.youtube\.com\/vi\/([\w-]{11})\/(?:maxresdefault|sddefault|hqdefault|mqdefault|default|0).jpg/;

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

		const ytUrl = searchParams.get('q');
		if (!ytUrl || !checkYtTnUrl.test(ytUrl)) {
			return objectNotFound();
		}

		let response = await fetch(ytUrl);
		// response = new Response(response.body, response);
		if (response.body === null) {
			return objectNotFound();
		}
		return new Response(response.body, { headers: corsHeaders });
	},
}
