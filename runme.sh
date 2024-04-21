#!/bin/bash

FILE="shared_file.txt"
STATS="stats.txt"

# Проверяем, существует ли файл stats.txt
if [ ! -f "$STATS" ]; then
    touch "$STATS"
fi

# Сохраняем время начала выполнения скрипта
start_time=$(date +%s)

# Запускаем 10 параллельных задач
for i in {1..10}; do
  (
    LOCK_COUNT=0
    while true; do
      # Проверяем, не истекло ли 30 секунд с момента начала выполнения задачи
      current_time=$(date +%s)
      if ((current_time - start_time >= 30)); then
        break
      fi
      
      ./lock "$FILE" && ((LOCK_COUNT++))
      sleep 1
    done
    echo "$LOCK_COUNT" >> "$STATS"
  ) &
  
  # Ограничиваем количество параллельно запускаемых задач
  if [ $(jobs -p | wc -l) -ge 10 ]; then
    wait -n
  fi
done

# Ожидаем завершения всех дочерних процессов
wait

# Выводим содержимое файла stats.txt
cat "$STATS"
