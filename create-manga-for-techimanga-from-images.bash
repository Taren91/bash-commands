TARGET_DIR="output"
CURRENT_DIR=$(pwd)

# Проверяем и создаём папку, если её нет
if [ ! -d "$TARGET_DIR" ]; then
    mkdir "$TARGET_DIR"
fi

# Перебираем все директории в текущей папке
for dir in */; do
    # Игнорирование папки $TARGET_DIR
    if [ "$(basename "$dir")" == "$TARGET_DIR" ]; then
        continue
    fi

    if [ -d "$dir" ]; then
        # Получаем имя директории и заменяем пробелы на подчёркивания
        dir_name=$(basename "$dir" | sed 's/ /_/g')

        # Создаём папку назначения
        mkdir -p "$TARGET_DIR/$dir_name"

        # Копируем содержимое текущей папки в новую папку
        cp -r "$dir" "$TARGET_DIR/$dir_name"

        # Создаём ZIP-архив
        zip -r "$TARGET_DIR/$dir_name/$dir_name.zip" "$dir"

        # Находим первый файл (с сортировкой) и копируем его
        first_file=$(ls -1 "$dir" | sort | head -n 1)
        if [ -n "$first_file" ]; then
            cp "$dir/$first_file" "$TARGET_DIR/$dir_name/"
        fi

        # Удаляем временные копии
        temp_path=$(realpath "$TARGET_DIR/$dir_name/$dir")
        rm -r -f "$temp_path"
    fi
done
