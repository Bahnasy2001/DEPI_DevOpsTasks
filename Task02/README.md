# **Task 02: User and Group Management, Script Permissions, and Archiving**

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Linux-Task01-Orange?style=flat&label=DevOps&labelColor=blue&color=gray)

## **Objective**

This task focuses on managing users, groups, file permissions, and archiving in a Unix/Linux environment.

## **Steps**

### 1. Create a Folder and Change User & Group Ownership

- Create a new folder using the `mkdir` command.
- Change the ownership of the folder to a specific user and group using the `chown` command.
> ```bash
> mkdir Task_2
> sudo chown bahnasy:bahnasy Task_2
> ```

### 2. Create script.sh and Change Permissions in Two Ways

- Create a shell script file named `script.sh` inside the folder.

> ```bash
> cd Task_2
> touch script.sh
> ```

- Change the file permissions using the `chmod` command. You can set permissions in two ways:
    - Using symbolic mode:
    > ```bash
    > chmod u+x,g+x,o+w+x script.sh
    > ```

    - Using numeric mode:
    > ```bash
    > chmod 644 script.sh
    > ```

- To Check the Permissions: Use command `ls -ltr`

### 3. Create a New User

- Create a new user using the `useradd` command.
> ```bash
> sudo useradd Hassan
> ```

- To Check the user: Use command `tail -1 /etc/passwd`

- To Check the group: Use Command `tail -1 /etc/group`

### 4. Change User & Group Ownership for the Script

- Change the ownership of `script.sh` to the newly created user and their primary group.
> ```bash
> chown Hassan:Hassan script.sh
> ```

### 5. Zip the Folder
Compress the folder created in step 1 into a `.zip` file using the `zip` command.
> ```bash
> zip -r Task_2.zip Task_2
> ```

## **Conclusion**

This task provides hands-on experience with essential system administration commands related to user and group management, file permissions, and archiving. Mastering these commands is crucial for effective system management in a DevOps role.