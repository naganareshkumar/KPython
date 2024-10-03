CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Resumes (
    resume_id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE
);
CREATE TABLE Emails (
    email_id SERIAL PRIMARY KEY,
    receiver VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    domain VARCHAR(255),
    body TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE
);
CREATE TABLE JobDescriptions (
    job_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    common_skills TEXT,
    missing_skills TEXT,
    email_id INT REFERENCES Emails(email_id) ON DELETE CASCADE
);
CREATE TABLE EmailResumeLink (
    email_resume_link_id SERIAL PRIMARY KEY,
    email_id INT REFERENCES Emails(email_id) ON DELETE CASCADE,
    resume_id INT REFERENCES Resumes(resume_id) ON DELETE CASCADE
);
