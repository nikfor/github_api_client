### Приложения для получения репозиториев юзеров и коммитов определенного репозитория.
- язык ruby 2.7.0
- фреймворк Sinatra

Описание:

* При запросе ресурса GET /user/:login приложение возвращает в ответе последние 10 репозиториев пользователя

```
Ресурс: /user/:login
Тип запроса: GET
Формат ответа: JSON
Структура ответа: 

{
  "response": {
    "user": {
      "name": "user name"
    },
    "repositories": [
      {
        "name": "repo name",
        "created_at": "repo created at date"
      }
    ]
  }
}
```
В противном случае, если искомого логина не существует вернется ошибка
```
Структура ответа:

{
  "response": {
    "error": “<Reason>"
  }
}
```
* При запросе ресурса GET /user/:login/:repo приложение возвращает в ответе последние 10 коммитов из master ветки запрашиваемого репозитория.

```
{
  "response": {
    "repo": {
      "name": "repo name",
      "commits": [
        {
          "message": "commit message",
          "commit_date": "date-of-commit"
        }
      ]
    }
  }
}
```

В противном случае, если искомого репозитория не существует вернется ошибка
```
Структура ответа:

{
  "response": {
    "error": “<Reason>"
  }
}
```




### DataMapper 

Mодуль для сопоставления входного набора параметров на новый набор параметров. 
Цель: чтобы системные аналитики компании могли составлять маппинг между сторонним апи и выходными параметрами(например для своего приложения)
Новый набор параметров добавляется в папку schemas сервиса data_mapper в виде файла yml. 
При добавлении файла yml необходимо придерживаться следующих соглашений:
* Данный файл является маппингом результирующего хеша на входной хеш. Соответственно путь к конечному параметру входного хеша лежит каждой конечной точке обходчика и разделяется символом '.' (точка), в следующем примере показано как будет создан новый хеш с одним ключем response c с вложенными ключами user и name. Значение из входного хэша(например input_hash) будет взято по следующему пути input_hash['data']['repositoryOwner']

```
response:
  user:
    name: "data.repositoryOwner"
```

* Если необходимо создать массив то предполагается что так же будет необходимо обойти массив из входного хэша. В таком случае необходимо в файле yml создать массив в первом элементе которого прописать какие поля будут созданы внутри каждого элемента массива, а во втором элементе прописать хэш с двумя параметрами:
   * path - путь до соответстующего массива во входном хэше начиная от предыдущего массива. 
   * only_base_types - если выставлен в true значит массив содержит только простые типы данных(числа строки), если false то массивы или хэши.
В следующем примере продемонстрировано описание двух массивов - авторов вложенных в массив репозиториев, таким образом первый автор первого репозитория будет отыскан по следующему пути во входном хэше input_hash['data']['repositoryOwner']['repositories']['edges'][0]['commiters']['authors'][0]

```
repositories:
    - name: "repo.name"
      created_at: "repo.created"
      authors: 
        - name: 'author.information.name'
          age: 'author.information.age'
          email: 'author.information.email'
        - path: 'commiters.authors'
          only_base_types: false
    - path: 'data.repositoryOwner.repositories.edges'
      only_base_types: false
```