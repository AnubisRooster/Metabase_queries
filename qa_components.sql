SELECT `jira_issues`.`resolution` AS `resolution`, count(distinct `jira_issues`.`id`) AS `count`
FROM `jira_issues`
WHERE ((`jira_issues`.`reporter` = 'Inna Murashko')
    OR (`jira_issues`.`reporter` = 'Yuliia Nedomirko'))
   AND ((`jira_issues`.`status` = 'Closed') OR (`jira_issues`.`status` = 'Code Ready') OR (`jira_issues`.`status` = 'Done')) AND ((`jira_issues`.`project` = 'Platform') OR (`jira_issues`.`project` = 'SingleStoreDB Cloud') OR (`jira_issues`.`project` = 'Web Development'))
   AND {{created_at}}
   AND {{project}}
GROUP BY `jira_issues`.`resolution`
ORDER BY `jira_issues`.`resolution` ASC
