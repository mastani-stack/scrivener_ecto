# Changelog

## 1.4.0-dev

* Don't allow `page_number` to be greater than `total_pages`

## 1.3.0

* Allow directly specifying `total_count`

## 1.2.3

* Handle complex group by statements in `total_count`

## 1.2.2

* Require Elixir `~> 1.3`

## 1.2.1

* Return `total_pages` of `1` when there are no results

## 1.2.0

* Supply `caller` when executing queries

## 1.1.4

* Exclude `order_by` before building a subquery

## 1.1.3

* Exclude `preload` and `select` before building a subquery

## 1.1.2

* Use `subquery` to calculate `total_count`

## 1.1.1

* Remove Elixir 1.4.0 warnings

## 1.1.0

* Support Ecto 2.1.x

## 1.0.3

* Gracefully handle no result when counting records

## 1.0.2

* Update postgrex dependency to 0.12.x

## 1.0.1

* Include scrivener in applications to support releases

## 1.0.0

* Initial release
