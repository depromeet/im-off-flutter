import 'dart:core';

class Job {
  final String jobName;
  const Job(this.jobName);

  String toString() => this.jobName;
}

const List<Job> jobs = [
  Job('경영・사무'),
  Job('마케팅・홍보'),
  Job('IT・개발'),
  Job('디자인'),
  Job('기획'),
  Job('무역・유통'),
  Job('영업・고객상당'),
  Job('서비스'),
  Job('연구개발・설계'),
  Job('생산・제조'),
  Job('교육'),
  Job('의료'),
  Job('법률'),
];
