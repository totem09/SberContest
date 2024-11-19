# Используем минимальный образ Python
FROM python:3.10-slim

# Устанавливаем рабочую директорию
WORKDIR /usr/src/app

# Копируем requirements.txt
COPY requirements.txt ./

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копируем исходный код приложения
COPY . .

# Используем непривилегированного пользователя
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
USER appuser

# Экспонируем порт
EXPOSE 5000

# Запускаем приложение
CMD ["python", "app.py"]
