<div align="center">

# LeetCode SQL Solutions

[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=flat-square&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](https://opensource.org/licenses/MIT)

*MySQL solutions to LeetCode database problems*

[Topics](#topics) - [Usage](#usage)

</div>

## Topics

<details>
<summary><strong>Basic SELECT &amp; Filtering</strong></summary>

| # | Problem | Difficulty | Solution |
| --- | --- | --- | --- |
| 577 | [Employee Bonus](https://leetcode.com/problems/employee-bonus) | Easy | [SQL](solutions/577_employee-bonus.sql) |
| 584 | [Find Customer Referee](https://leetcode.com/problems/find-customer-referee) | Easy | [SQL](solutions/584_find-customer-referee.sql) |
| 595 | [Big Countries](https://leetcode.com/problems/big-countries) | Easy | [SQL](solutions/595_big-countries.sql) |
| 620 | [Not Boring Movies](https://leetcode.com/problems/not-boring-movies) | Easy | [SQL](solutions/620_not-boring-movies.sql) |
| 1148 | [Article Views I](https://leetcode.com/problems/article-views-i) | Easy | [SQL](solutions/1148_article-views-i.sql) |
| 1204 | [Last Person to Fit in the Bus](https://leetcode.com/problems/last-person-to-fit-in-the-bus) | Medium | [SQL](solutions/1204_last-person-to-fit-in-the-bus.sql) |
| 1527 | [Patients With a Condition](https://leetcode.com/problems/patients-with-a-condition) | Easy | [SQL](solutions/1527_patients-with-a-condition.sql) |
| 1683 | [Invalid Tweets](https://leetcode.com/problems/invalid-tweets) | Easy | [SQL](solutions/1683_invalid-tweets.sql) |
| 1757 | [Recyclable and Low-Fat Products](https://leetcode.com/problems/recyclable-and-low-fat-products) | Easy | [SQL](solutions/1757_recyclable-and-low-fat-products.sql) |
| 1890 | [The Latest Login in 2020](https://leetcode.com/problems/the-latest-login-in-2020) | Easy | [SQL](solutions/1890_the-latest-login-in-2020.sql) |
| 3436 | [Find Valid Emails](https://leetcode.com/problems/find-valid-emails) | Easy | [SQL](solutions/3436_find-valid-emails.sql) |
| 3570 | [Find Books with No Available Copies](https://leetcode.com/problems/find-books-with-no-available-copies) | Easy | [SQL](solutions/3570_find-books-with-no-available-copies.sql) |

</details>

<details>
<summary><strong>DML / DELETE &amp; UPDATE</strong></summary>

| # | Problem | Difficulty | Solution |
| --- | --- | --- | --- |
| 196 | [Delete Duplicate Emails](https://leetcode.com/problems/delete-duplicate-emails) | Easy | [SQL](solutions/196_delete-duplicate-emails.sql) |
| 627 | [Swap Sex of Employees](https://leetcode.com/problems/swap-sex-of-employees) | Easy | [SQL](solutions/627_swap-sex-of-employees.sql) |

</details>

## Usage

Each solution is a standalone SQL statement. Run it against the matching schema:

```bash
mysql -u root -p your_database < solutions/595_big-countries.sql
```

Solutions are named `<leetcode_id>_<problem-slug>.sql` so they line up with the problem URL.
