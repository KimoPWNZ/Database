WITH RECURSIVE Subordinates AS (
    SELECT
        EmployeeID,
        Name,
        ManagerID,
        DepartmentID,
        RoleID
    FROM
        Employees
    WHERE
        EmployeeID = 1

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM
        Employees e
    INNER JOIN
        Subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT
    s.EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    STRING_AGG(DISTINCT p.ProjectName, ', ') AS ProjectNames,
    STRING_AGG(DISTINCT t.TaskName, ', ') AS TaskNames
FROM
    Subordinates s
LEFT JOIN
    Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN
    Roles r ON s.RoleID = r.RoleID
LEFT JOIN
    Projects p ON d.DepartmentID = p.DepartmentID
LEFT JOIN
    Tasks t ON s.EmployeeID = t.AssignedTo
GROUP BY
    s.EmployeeID, s.Name, s.ManagerID, d.DepartmentName, r.RoleName
ORDER BY
    s.Name;