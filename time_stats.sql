with jira_change_log as (select cl.issue_id,
                                cl.author,
                                cl.author_email,
                                sharehouse.tz_timestamp_to_utc(cl.change_date)  as change_date,
                                json_extract_string(ca.table_col, 'field')      as change_field,
                                json_extract_string(ca.table_col, 'fromString') as change_from,
                                json_extract_string(ca.table_col, 'toString')   as change_to
                         from (select i.IssueKey                                                 as issue_id,
                                      json_extract_string(c.table_col, 'author', 'displayName')  as author,
                                      json_extract_string(c.table_col, 'author', 'emailAddress') as author_email,
                                      json_extract_string(c.table_col, 'created')                as change_date,
                                      json_extract_json(c.table_col, 'items')                    as change_attrs
                               from jira.issues_src i,
                                    table(json_to_array(i.ChangeLog)) c) cl,
                              table(json_to_array(cl.change_attrs)) ca)
select cl.issue_id,
       lag(cl.author) over (partition by cl.issue_id order by cl.change_date) as change_author,
       cl.change_from                                                         as status,
       coalesce(lag(cl.change_date) over (partition by cl.issue_id order by cl.change_date),
                ji.created_at)                                                as status_from,
       cl.change_date                                                         as status_to,
       concat(format(floor(timestampdiff(second, status_from, cl.change_date) / (3600 * 24)), 0), ' days ',
              time_format(sec_to_time(timestampdiff(second, status_from, cl.change_date) % (3600 * 24)),
                          '%H Hours : %i Minutes : %s Seconds'))              as time_in_status
from jira_change_log cl
         join project_management.jira_issues ji on cl.issue_id = ji.id
where change_field = 'status'
  and issue_id = '[issueID]'     # change the issue number here
order by change_date;
