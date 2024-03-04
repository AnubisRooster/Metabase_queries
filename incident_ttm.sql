SELECT AVG(`jira_ticket_changeTime`.`Hours_No_Weekends`) AS `avg`
FROM `jira_ticket_changeTime`
LEFT JOIN `jira_issues` AS `jira_issues` ON `jira_ticket_changeTime`.`issue_id` = `jira_issues`.`id`
WHERE LOWER(`jira_issues`.`summary`) LIKE 'inc-%'
   AND (`jira_issues`.`status` = 'Closed' OR `jira_issues`.`status` = 'Code Ready' OR `jira_issues`.`status` = 'Done')
   AND `jira_issues`.`summary` NOT LIKE 'rca:%';
