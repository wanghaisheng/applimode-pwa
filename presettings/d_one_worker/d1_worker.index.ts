/*
export interface Env {
	// If you set another name in wrangler.toml as the value for 'binding',
	// replace "DB" with the variable name you defined.
	DB: D1Database;
	AUTH_KEY_SECRET: string;
}

const corsHeaders = {
	'Access-Control-Allow-Origin': '*',
	'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,OPTIONS',
	// 'Access-Control-Allow-Headers': '*',
	// 'Access-Control-Max-Age': '86400',
}

const hasValidHeader = (request: Request, env: Env) => {
	return request.headers.get('X-Custom-Auth-Key') === env.AUTH_KEY_SECRET;
};

function authorizeRequest(request: Request, env: Env) {
	switch (request.method) {
		case 'GET':
			return true;
		case 'HEAD':
			return true;
		case 'DELETE':
			return true; // hasValidHeader(request, env);
		case 'PUT':
			return true; // hasValidHeader(request, env);
		case 'POST':
			return true; // hasValidHeader(request, env);
	}
	// return hasValidHeader(request, env)
}

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
		});
	} else {
		return new Response(null, {
			headers: {
				...corsHeaders,
				Allow: "GET, PUT, POST, DELETE, OPTIONS",
			},
		});
	}
}

export default {
	async fetch(request: Request, env: Env): Promise<Response> {
		const url = new URL(request.url);
		const pathname = url.pathname;

		if (request.method === 'OPTIONS') {
			return handleOptions(request);
		}

		if (!authorizeRequest(request, env)) {
			return new Response('Forbidden', { status: 403, headers: corsHeaders });
		}

		if (request.method === 'GET') {
			if (pathname === "/api/posts") {

				const searchParams = url.searchParams;
				if (searchParams === null || !searchParams.toString()) {
					return objectNotFound();
				}

				const search = searchParams.get('q');
				if (!search) {
					return objectNotFound();
				}
				const start = searchParams.get('s');
				const modified = search.replace(' ', '* OR ') + '*';
				console.log(`modified: ${modified}`);
				const { results } = start ? await env.DB.prepare(
					"SELECT pid FROM posts WHERE posts Match ?1 ORDER BY rowid DESC LIMIT ?2, 21"
				)
					.bind(modified, start)
					.all() : await env.DB.prepare(
						"SELECT pid FROM posts WHERE posts Match ? ORDER BY rowid DESC LIMIT 21"
					)
						.bind(modified)
						.all();
				return Response.json(results, {
					headers: { ...corsHeaders, 'content-type': 'application/json; charset=UTF-8' },
				});
			}

			if (pathname === "/api/posts/all") {

				const searchParams = url.searchParams;
				if (searchParams === null || !searchParams.toString()) {
					return objectNotFound();
				}

				const search = searchParams.get('q');
				if (!search) {
					return objectNotFound();
				}
				const modified = search.replace(' ', '* OR ') + '*';
				const { results } = await env.DB.prepare(
						"SELECT pid FROM posts WHERE posts Match ? ORDER BY rowid DESC LIMIT 500"
					)
						.bind(modified)
						.all();
				return Response.json(results, {
					headers: { ...corsHeaders, 'content-type': 'application/json; charset=UTF-8' },
				});
			}

			return objectNotFound();
		}

		if (request.method == 'POST') {
			if (pathname.startsWith("/api/posts")) {
				const pid = pathname.replace("/api/posts/", "");
				const body = await request.text();
				console.log(`body: ${body}`);
				if (!pid || !body) {
					return objectNotFound();
				}
				await env.DB.prepare(
					"INSERT INTO posts (pid, body) VALUES (?1, ?2)"
				)
					.bind(pid, body)
					.run();
				return new Response(null, {
					status: 302,
					headers: {
						...corsHeaders,
					}
				})
			}
			return objectNotFound();
		}

		if (request.method === 'PUT') {
			if (pathname.startsWith("/api/posts")) {
				const pid = pathname.replace("/api/posts/", "");
				const body = await request.text();
				console.log(`body: ${body}`);
				if (!pid || !body) {
					return objectNotFound();
				}
				await env.DB.prepare(
					"UPDATE posts SET body=?2 WHERE posts MATCH ?1"
				)
					.bind(`"${pid}"`, body)
					.run();
				return new Response(null, {
					status: 302,
					headers: {
						...corsHeaders,
					}
				})
			}
			return objectNotFound();
		}

		if (request.method === 'DELETE') {
			if (pathname.startsWith("/api/posts")) {
				const pid = pathname.replace("/api/posts/", "");
				if (!pid) {
					return objectNotFound();
				}
				await env.DB.prepare(
					"DELETE FROM posts WHERE posts MATCH ?"
				)
					.bind(`"${pid}"`)
					.run();
				return new Response(null, {
					status: 200,
					headers: {
						...corsHeaders,
					}
				})
			}
			return objectNotFound();
		}
		return objectNotFound();
	},
};
*/