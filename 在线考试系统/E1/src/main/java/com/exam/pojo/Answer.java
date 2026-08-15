package com.exam.pojo;

public class Answer {
    private String id;
    private String questionId;
    private String studentUsername;
    private String content;       // 答案内容
    private String submitTime;    // 新增：提交时间

    public Answer() {
    }

    public Answer(String id, String questionId, String studentUsername, String content, String submitTime) {
        this.id = id;
        this.questionId = questionId;
        this.studentUsername = studentUsername;
        this.content = content;
        this.submitTime = submitTime;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getQuestionId() {
        return questionId;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public String getStudentUsername() {
        return studentUsername;
    }

    public void setStudentUsername(String studentUsername) {
        this.studentUsername = studentUsername;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSubmitTime() {
        return submitTime;
    }

    public void setSubmitTime(String submitTime) {
        this.submitTime = submitTime;
    }
}
