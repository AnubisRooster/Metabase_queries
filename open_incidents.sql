SELECT count(distinct `jira_issues`.`id`) AS `count`
FROM `jira_issues`
WHERE LOWER(`jira_issues`.`summary`) LIKE 'inc-%'
   AND (`jira_issues`.`status` != 'Closed') AND (`jira_issues`.`status` != 'Code Ready') AND (`jira_issues`.`status` != 'Done')
   OR (`jira_issues`.`project` = 'Engineering Customer Support') AND (`jira_issues`.`issue_type` = 'Incident') AND (`jira_issues`.`status` != 'Done')
    
