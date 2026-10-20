CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT DETERMINISTIC
RETURN (
    SELECT e.salary
    FROM (SELECT DISTINCT salary FROM Employee) e
    WHERE (SELECT COUNT(DISTINCT e2.salary)
           FROM Employee e2
           WHERE e2.salary > e.salary) = N - 1
);