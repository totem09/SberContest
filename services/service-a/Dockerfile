# Используем минимальный образ Node.js
FROM node:18-alpine

# Устанавливаем рабочую директорию
WORKDIR /usr/src/app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем только продакшн зависимости
RUN npm install
RUN npm ci --omit=production

# Копируем исходный код приложения
COPY . .

# Используем непривилегированного пользователя
RUN addgroup appgroup && adduser -S -G appgroup appuser
USER appuser

# Экспонируем порт
EXPOSE 5000

# Запускаем приложение
CMD ["node", "app.js"]
