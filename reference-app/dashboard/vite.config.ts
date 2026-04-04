import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';

export default defineConfig({
	plugins: [tailwindcss(), sveltekit()],
	server: {
		proxy: {
			// Development proxy: forward service health calls to local services
			'/api-gateway': {
				target: 'http://localhost:8080',
				changeOrigin: true,
				rewrite: (path) => path.replace(/^\/api-gateway/, '')
			},
			'/catalog': {
				target: 'http://localhost:8081',
				changeOrigin: true,
				rewrite: (path) => path.replace(/^\/catalog/, '')
			},
			'/worker': {
				target: 'http://localhost:8082',
				changeOrigin: true,
				rewrite: (path) => path.replace(/^\/worker/, '')
			}
		}
	}
});
