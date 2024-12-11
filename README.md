# taskwarrior
For now, just some random handmade hooks

## on-add.anniversaire.sh

Bash hook that help setup birthdays when a recur task is added on a specific project.
help with fixing the date around leap year, also add the age of the person in the description
while auto completing past years.

### usage

```bash
task add "Foo Bar" project:Social.Anniversaire recur:1y due:1997-05-04
```

> **project:"..."**

need to be the one defined in the hook

> **recur:1y**

Well, it happen every year, must be set to work

> due:YYYY-MM-DD

The birth day of the person

### variables
line 8
```
TARGET="Social.Anniversaire"
```
Change the target to define the project that will trigger the hook

### issues

People born before 1980-02-01 cannot be added in this version, because timestamp are used

## on-modify.frequency.sh

Bash hook that help setup recuring task with a due date based on the completed date

### requirements

The .taskrc file need to declare an UDA called frequency of type string

> uda.frequency.type=string

### usage
```bash
task add "things" frequency:"3 day"
task X done
```

> **frequency:"..."**

recurence of the task, use the [bash date command]([https://www.man7.org/linux/man-pages/man1/date.1.html](https://www.cyberciti.biz/faq/how-to-add-days-to-date-and-get-new-date-on-linux/)) calculating ability to define the next due date

### issues

Did not find any yet
