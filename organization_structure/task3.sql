WITH RECURSIVE ManagerHierarchy AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        0 AS Level
    FROM
        Employees e
    WHERE
        e.RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Менеджер')

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        mh.Level + 1
    FROM
        Employees e
    INNER JOIN
        ManagerHierarchy mh ON e.ManagerID = mh.EmployeeID
),
ManagerInfo AS (
    SELECT
        mh.EmployeeID,
        mh.Name AS EmployeeName,
        mh.ManagerID,
        d.DepartmentName,
        r.RoleName,
        STRING_AGG(DISTINCT p.ProjectName, ', ') AS ProjectNames,
        STRING_AGG(DISTINCT t.TaskName, ', ') AS TaskNames,
        COUNT(DISTINCT e.EmployeeID) AS TotalSubordinates
    FROM
        ManagerHierarchy mh
    LEFT JOIN
        Departments d ON mh.DepartmentID = d.DepartmentID
    LEFT JOIN
        Roles r ON mh.RoleID = r.RoleID
    LEFT JOIN
        Projects p ON d.DepartmentID = p.DepartmentID
    LEFT JOIN
        Tasks t ON mh.EmployeeID = t.AssignedTo
    LEFT JOIN
        Employees e ON mh.EmployeeID = e.ManagerID
    WHERE
        mh.Level = 0
    GROUP BY
        mh.EmployeeID, mh.Name, mh.ManagerID, d.DepartmentName, r.RoleName
)
SELECT
    EmployeeID,
    EmployeeName,
    ManagerID,
    DepartmentName,
    RoleName,
    ProjectNames,
    TaskNames,
    TotalSubordinates
FROM
    ManagerInfo
WHERE
    TotalSubordinates > 0
ORDER BY
    EmployeeName;