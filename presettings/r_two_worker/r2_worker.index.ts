/*
export interface Env {
	// Example binding to R2. Learn more at https://developers.cloudflare.com/workers/runtime-apis/r2/
	MY_BUCKET: R2Bucket;
	AUTH_KEY_SECRET: string;
}

const corsHeaders = {
	'Access-Control-Allow-Origin': '*',
	'Access-Control-Allow-Methods': 'GET,HEAD,PUT,POST,DELETE,OPTIONS',
	// 'Access-Control-Allow-Headers': '*',
	// 'Access-Control-Max-Age': '86400',
}

const hasValidHeader = (request: Request, env: Env) => {
	return request.headers.get('X-Custom-Auth-Key') === env.AUTH_KEY_SECRET;
};

function authorizeRequest(request: Request, env: Env, key: String) {
	switch (request.method) {
		case 'GET':
			return true;
		case 'HEAD':
			return true;
		case 'DELETE':
			return hasValidHeader(request, env)
		case 'PUT':
			return hasValidHeader(request, env)
		case 'POST':
			return hasValidHeader(request, env)
	}
	// return hasValidHeader(request, env)
}

function objectNotFound(objectName: string): Response {
	return new Response(`<html><body>R2 object "<b>${objectName}</b>" not found</body></html>`, {
		status: 404,
		headers: {
			...corsHeaders,
			'content-type': 'text/html; charset=UTF-8'
		}
	})
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
				Allow: "GET, HEAD, PUT, POST, DELETE, OPTIONS",
			},
		})
	}
}

export default {
	async fetch(request: Request, env: Env): Promise<Response> {
		const url = new URL(request.url)
		const objectName = url.pathname.slice(1)

		// console.log(`${request.method} object ${objectName}: ${request.url}`)

		if (request.method === 'OPTIONS') {
			return handleOptions(request)
		}
		if (!authorizeRequest(request, env, objectName)) {
			return new Response('Forbidden', { status: 403, headers: corsHeaders })
		}

		if (request.method === 'GET' || request.method === 'HEAD') {
			if (objectName === '') {
				if (request.method == 'HEAD') {
					return new Response(undefined, { status: 400, headers: corsHeaders })
				}

				const options: R2ListOptions = {
					prefix: url.searchParams.get('prefix') ?? undefined,
					delimiter: url.searchParams.get('delimiter') ?? undefined,
					cursor: url.searchParams.get('cursor') ?? undefined,
					include: ['customMetadata', 'httpMetadata'],
				}
				// console.log(JSON.stringify(options))

				const listing = await env.MY_BUCKET.list(options)
				return new Response(JSON.stringify(listing), {
					headers: { ...corsHeaders, 'content-type': 'application/json; charset=UTF-8' },
				})
			}

			if (request.method === 'GET') {
				const range = request.headers.get('range');
				// const video = await env.MY_BUCKET.get(objectName);

				if (range) {
					const object = await env.MY_BUCKET.get(objectName, {
						range: request.headers,
					});

					if (object === null) {
						return objectNotFound(objectName)
					}

					const parts = range.replace(/bytes=/, '').split('-');
					const start = parseInt(parts[0], 10);
					const end =
						parts[1]
							? parseInt(parts[1], 10)
							: object.size - 1;
					const contentLength = end - start + 1;
					
					
					const headers = new Headers();
					object.writeHttpMetadata(headers);
					headers.set("etag", object.httpEtag);
					// headers.set("Content-Type", "video/mp4");
					headers.set("Accept-Ranges", "bytes");
					headers.set("Content-Range", `bytes ${start}-${end}/${object.size}`);
					headers.set("Content-Length", `${contentLength}`);
					headers.set('Access-Control-Allow-Origin', '*')
					// headers.set('Access-Control-Allow-Methods', 'GET,HEAD,PUT,POST,DELETE,OPTIONS')
					// headers.set('Access-Control-Allow-Headers', '*')

					return new Response(object.body, {
						headers,
						status: 206,
					});
				}

				const object = await env.MY_BUCKET.get(objectName)

				if (object === null) {
					return objectNotFound(objectName)
				}

				const headers = new Headers()
				object.writeHttpMetadata(headers)
				headers.set('etag', object.httpEtag)
				headers.set('Access-Control-Allow-Origin', '*')
				// headers.set('Access-Control-Allow-Methods', 'GET,HEAD,PUT,POST,DELETE,OPTIONS')
				// headers.set('Access-Control-Allow-Headers', '*')
				// headers.set('Content-Type', 'application/json')
				// headers.set("Accept-Ranges", "bytes")


				return new Response(object.body, {
					headers,
				})
			}

			const object = await env.MY_BUCKET.head(objectName)

			if (object === null) {
				return objectNotFound(objectName)
			}

			const headers = new Headers()
			object.writeHttpMetadata(headers)
			headers.set('etag', object.httpEtag)
			headers.set('Access-Control-Allow-Origin', '*')
			// headers.set('Access-Control-Allow-Methods', 'GET,HEAD,PUT,POST,DELETE,OPTIONS')
			// headers.set('Access-Control-Allow-Headers', '*')
			return new Response(null, {
				headers,
			})
		}

		if (request.method === 'PUT' || request.method == 'POST') {
			const object = await env.MY_BUCKET.put(objectName, request.body, {
				httpMetadata: request.headers,
			})
			return new Response(null, {
				headers: {
					...corsHeaders,
					'etag': object.httpEtag,
				}
			})
		}
		if (request.method === 'DELETE') {
			await env.MY_BUCKET.delete(url.pathname.slice(1))
			return new Response(JSON.stringify({ status: 'success' }), {
				status: 200,
				headers: corsHeaders,
			})
		}

		return new Response(`Unsupported method`, {
			status: 400,
			headers: corsHeaders,
		})
	}
}
*/
