# Методы принятия решений

## Навигация

- [Метрические алгоритмы классификации](#Метрические-алгоритмы-классификации)
  - [Алгоритм ближайших соседей](#Алгоритм-ближайших-соседей)
  - [Алгоритм k взвешенных ближайших соседей](#Алгоритм-k-взвешенных-ближайших-соседей)

# Постановка задачи
 В пространстве объектов задаем функцию расстояния, характеризующая степень близости объектов. Нам дана обучающая выборка и объект, который нужно отнести к одному из существующих классов (классифицировать). Решать задачу мы будем при помощи обучающей выборки "Ирисы Фишера".
Данная выборка содержит 150 объектов-ирисов: по 50 объектов каждого из трех классов. Ирис представлен четырьмя признаками: длинной и шириной чашелистика и лепестка. 
  
# Метрические алгоритмы классификации
**Метрические методы обучения** - методы, основанные на анализе сходства объектов. Метрические алгоритмы классификации опираются на гипотезу компактности: схожим объектам соответствуют схожие ответы. 
Для поиска оптимальных параметров для каждого из рассматриваемых ниже метрических алгоритмов используется **LOO -- leave-one-out** (критерий скользящего контроля), который состоит в следующем:

1. Исключать по одному объекту  из выборки, получаем новую выборку без исключенных объектов (назовём её Xl_1).
2. Запускать алгоритм от объекта, который нужно классифицировать, на новой выборке Xl_1.
3. Завести переменную ошибки, и, когда алгоритм ошибается, Q = Q + 1 (изначально Q = 0).
4. Когда все объекты будут перебраны, вычислить LOO, частное от ошибки и количества объектов выборки.
Оптимальный алгоритм получим при минимальном скользящем контроле (LOO).
Преимущества LOO в том, что каждый объект ровно один раз участвует в контроле, а длина обучающих подвыборок лишь на единицу меньше длины полной выборки.
Недостатком LOO является большая ресурсоёмкость, так как обучаться приходится L раз.

## Алгоритм ближайших соседей
### 1NN
1. На первом шаге подбираем метрику (в данном случае это евклидово пространство). 
2. Считаем расстояние от классифицируемого объекта, до объектов выборки, заносим значения в массив расстояний. 
3. Сортируем масив по возрастанию (от ближнего элемента к дальнему). 
4. Находим класс первого элемента массива, и относим классифицируемый объект к этому классу.

Результат работы алгоритма:
  
 ![](https://github.com/Abkelyamova/SMPR_AbkelyamovaGulzara/blob/master/NN.png)
 
 ### KNN
 
Алгоритм выбирает _k_ ближайших соседей, возвращает тот класс, который среди выбранных встречается большее количество раз и относит классифицируемый объект *u* этому классу.
Для оценки близости объекта *u* к классу *y* алгоритм **kNN** использует следующую функцию: ![](http://latex.codecogs.com/svg.latex?%5Clarge%20W%28i%2C%20u%29%20%3D%20%5Bi%20%5Cleq%20k%5D) , где *i* -- порядок соседа по расстоянию к классифицируемому объекту u.
LOO для KNN показал что оптимальное k = 6.
Результат работы алгоритма: 
![](https://github.com/Abkelyamova/SMPR_AbkelyamovaGulzara/blob/master/6NN.png)

Скользящий контроль для алгоритма KNN:
```diff
LOO <- function(xl,class) 
{
  n <- dim(xl)[1];
  loo <- rep(0, n-1) 
  for(i in 1:n)
  {
    X <- xl[-i, 1:3]
    u <- xl[i, 1:2]
    orderedXl <- sortObjectByDist(X, u)
    for(k in 1:(n-1))
    {
      test <- knn(X,u,k,orderedXl)
      if(colors[test] != colors[class[i]])
      {
        loo[k] <- loo[k]+1;
      }
    }
  }
```

![](https://github.com/Abkelyamova/SMPR_AbkelyamovaGulzara/blob/master/loo_knn.png)
#### Преимущества:

- При *k*, подобранном около оптимального, алгоритм "неплохо" классифицирует.

#### Недостатки:
- Нужно хранить всю выборку.
- При *k = 1* неустойчивость к погрешностям (*выбросам* -- объектам, которые окружены объектами чужого класса), вследствие чего этот выброс классифицировался неверно и окружающие его объекты, для которого он окажется ближайшим, тоже.
- При *k = l* алгоритм наоборот чрезмерно устойчив и вырождается в константу.
- Максимальная сумма объектов в *counts* может достигаться в нескольких классах одновременно.
- Точки, расстояние между которыми одинаково, не все будут учитываться.

## Алгоритм k взвешенных ближайших соседей
### KwNN
Данный алгоритм классификации относит объект *u* к тому классу *y*, у которого максимальна сумма весов из его *k* соседей, то есть объект относится к тому классу, который набирает больший суммарный вес среди k ближайших соседей.
В данном алгоритме, помимо функции расстояния, используется весовая функция, которая оценивает степень важности при классификации заданного объекта к какому-либо классу, что и отличает его от алгоритма kNN.

Результат роботы алгоритма:
![](https://github.com/Abkelyamova/SMPR_AbkelyamovaGulzara/blob/master/KwNN.png)
#### Недостатки:
1. Приходится хранить обучающую выборку Xl целиком, что приводит к неэффективному расходу памяти. При наличии погрешностей это может привести к понижению точности классификации вблизи границ классов.
2. Исключается настройка алгоритмов по данным (крайне "бедный" набор параметров).
3. Если суммарные веса классов оказываются одинаковыми, то алгоритм относит классифицируемый объект u к любому из классов.
#### Преимущества:
При любом k алгоритм неплохо классифицирует. 
### Сравнение качества алгоритмов KNN и KwNN.
Пример показывающий преимущество метода kwNN над kNN: 
![](https://github.com/Abkelyamova/SMPR_AbkelyamovaGulzara/blob/master/knn&kwnn.png)
#### Чем kwnn лучше/хуже knn?
- То же самое, что и knn
- Шире диапазон оптимальных k.
- Лучше точность на границах.
<table>
<tr><td>Метод</td><td>параметры</td><td>величина ошибок</td><tr>
<tr><td> KNN</td><td>k=6</td><td>0.33</td><tr>
<tr><td> KWNN</td><td>k=9</td><td>0.33</td<tr>
 <table>
