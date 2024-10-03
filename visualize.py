from eralchemy import render_er

# Define the data model in text
data_model = '''
[Users] | user_id | email | name | created_at
[Resumes] | resume_id | filename | uploaded_at | user_id
[Emails] | email_id | receiver | subject | domain | body | sent_at | user_id
[JobDescriptions] | job_id | description | common_skills | missing_skills | email_id
[EmailResumeLink] | email_resume_link_id | email_id | resume_id

Users ||--o{ Resumes : uploads
Users ||--o{ Emails : sends
Emails ||--o{ JobDescriptions : describes
Emails ||--o{ EmailResumeLink : links
Resumes ||--o{ EmailResumeLink : linked_with
'''

# Render the data model to a PNG file
output_file = '/mnt/data/relational_data_model.png'
render_er(data_model, output_file)