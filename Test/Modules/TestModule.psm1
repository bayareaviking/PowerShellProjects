class Employee {
    [string]$FirstName
    [string]$LastName 
    [string]$Department
    [string]$Title

    Employee(){ }

   Employee([string]$firstName, [string]$lastName, [string]$department, [string]$title) {
        $this.FirstName = $firstName
        $this.LastName = $lastName
        $this.Department = $department
        $this.Title = $title
    }

    [string]PrintEmployeeInfo() {
        [string]$returnVal = $this.FirstName + " " + $this.LastName + " works in the " + $this.Department + " department as a " + $this.Title + "."
        return $returnVal
    }
}