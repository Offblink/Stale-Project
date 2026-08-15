package com.exam.pojo;

public class Grade {
    private String id;
    private String answerId;
    private String score;
    private String teacherUsername;

    public Grade() {
    }

    public Grade(String id, String answerId, String score, String teacherUsername) {
        this.id = id;
        this.answerId = answerId;
        this.score = score;
        this.teacherUsername = teacherUsername;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAnswerId() {
        return answerId;
    }

    public void setAnswerId(String answerId) {
        this.answerId = answerId;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public String getTeacherUsername() {
        return teacherUsername;
    }

    public void setTeacherUsername(String teacherUsername) {
        this.teacherUsername = teacherUsername;
    }
}
