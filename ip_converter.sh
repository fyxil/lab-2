#!/bin/bash

# Проверяем, был ли передан аргумент
if [ $# -ne 1 ]; then
    echo "Использование: $0 <IPv4-адрес>"
    echo "Пример: $0 192.168.10.1"
    exit 1
fi

ip=$1
binary_ip=""

# Функция для конвертации десятичного числа в двоичное
dec2bin() {
    local num=$1
    local binary=""
    
    # Конвертируем число в двоичный формат
    for (( i=7; i>=0; i-- )); do
        bit=$(( num >> i & 1 ))
        binary="${binary}${bit}"
    done
    
    echo "$binary"
}

# Разделяем IP-адрес на части и конвертируем каждую
IFS='.' read -r -a parts <<< "$ip"

# Проверяем, что у нас ровно 4 части
if [ ${#parts[@]} -ne 4 ]; then
    echo "Ошибка: неверный формат IP-адреса"
    exit 1
fi

for part in "${parts[@]}"; do
    # Проверяем, является ли часть числом от 0 до 255
    if ! [[ "$part" =~ ^[0-9]+$ ]] || [ "$part" -lt 0 ] || [ "$part" -gt 255 ]; then
        echo "Ошибка: '$part' не является допустимой частью IP-адреса (0-255)"
        exit 1
    fi
    
    # Конвертируем в двоичный формат
    binary=$(dec2bin "$part")
    
    # Добавляем часть к результату
    if [ -z "$binary_ip" ]; then
        binary_ip="$binary"
    else
        binary_ip="$binary_ip.$binary"
    fi
done

echo "$binary_ip" 