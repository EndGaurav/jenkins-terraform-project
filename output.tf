output "jenkins_url" {
    value = join("", ["http://", aws_instance.jenkins_instance.public_dns, ":","8080"])
}