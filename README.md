lock.c - файл с кодом на С

runme.sh - скрипт для запуска 10 задач

stats.txt - файл куда записывается статистика после выполнения скрипта

shared_file.txt - общий файл для блокировки

Перед запуском нужно выполнить команды:
1) Скомпилировать lock.c /n
gcc lock.c -o lock
2) Дать скрипту права на исполнение /n
chmod +x runme.sh

Далее нужно запустить сам скрипт и передать название файла для блокировки
./runme.sh shared_file.txt