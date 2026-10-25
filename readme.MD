### Vulnerabilities
Security weaknesses in the code that attackers could exploit.

### Bugs
Coding errors that can cause the application to behave incorrectly.

### Code Smells
Code that works but is poorly written or difficult to maintain.
Example: Repeating the same block of code in multiple places.

### Maintainability Rating
Indicates how maintainable the code is, based on technical debt ratio.

### Code Coverage
The percentage of executable code covered by automated tests.

### unit test
* Unit testing will give us a JSON report
* Total test cases executed
* How many passed, How many failed
* This report should be uploaded to SonarQube server through agent.

### Security Rating
* Measures the severity of detected vulnerabilities. In the traditional rating system, A means no vulnerabilities; B–E correspond to increasingly severe vulnerabilities.

### Maintainability
* Maintainability means how easy or difficult it is to modify and maintain your code.
* SonarQube uses the Technical Debt Ratio to determine the traditional Maintainability Rating.

### Remediation Cost
Remediation cost means the estimated time and effort needed to fix a problem in your code.

### Reliability Rating
Reliability Rating tells you how serious the bugs detected in your code are.

### Technical debt ratio:
is a metric measures cost of fixing technical debt to total cost of building software or application
cost of fixing technical debt = 200
total cost = 10000
      TDR = (200/10000)*100
        = 20 %

### CVSS(Common vulnerabilitiy scoring system):
is a standard measure severity of security vulnerabilities.

### Rating grades
🟢 A	Excellent
🟢 B	Good
🟡 C	Needs improvement
🟠 D	Poor
🔴 E	Worst

### install trivy
1. create trivy repo
    ```
    sudo tee /etc/yum.repos.d/trivy.repo <<'EOF'
    [trivy]
    name=Trivy repository
    baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
    EOF
    ```
2. Update packages

     ``` sudo dnf makecache ```

3.  Install Trivy

    ``` sudo dnf install trivy -y ```