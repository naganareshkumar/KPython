SELECT role_name FROM Roles 
INNER JOIN UserRoles ON Roles.role_id = UserRoles.role_id
WHERE user_id = <specific_user_id>;


SELECT permission_name FROM Permissions
INNER JOIN RolePermissions ON Permissions.permission_id = RolePermissions.permission_id
WHERE role_id = (SELECT role_id FROM UserRoles WHERE user_id = <specific_user_id>);


SELECT permission_name FROM Permissions
INNER JOIN RolePermissions ON Permissions.permission_id = RolePermissions.permission_id
WHERE role_id = (SELECT role_id FROM UserRoles WHERE user_id = <specific_user_id>);

SELECT * FROM Resumes WHERE user_id = <specific_user_id>;

SELECT * FROM Pages WHERE page_name = '<page_name>'
AND role_id = (SELECT role_id FROM UserRoles WHERE user_id = <specific_user_id>);

