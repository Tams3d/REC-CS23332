CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT DETERMINISTIC
RETURN (
    SELECT DISTINCT salary
    FROM (
        SELECT salary,
               DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM Employee
    ) t
    WHERE rnk = N
);
