import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    outDir: 'src/main/webapp/dist', // 构建到此目录下
    rollupOptions: {
      input: {
        main: 'src/main/webapp/js/app.js' // 读取此js文件并构建main.js
      },
      output: {
        entryFileNames: 'assets/main.js',
        chunkFileNames: 'assets/[name].js',
        assetFileNames: 'assets/[name].[ext]'
      }
    }
  }
});