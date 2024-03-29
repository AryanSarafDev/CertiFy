# CertiFy - A blockchain based certificate issuing & verification platform.

CertiFy is a blockchain-based certificate issuing and verification application built with Flutter, using Supabase as its database and Solidity for its Smart Contract, compatible with any EVM (Ethereum Virtual Machine).


## App Screenshots
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/1.jpg)
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/2.jpg)
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/3.jpg)
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/4.jpg)
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/5.jpg)
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/6.jpg)
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/7.jpg)


https://github.com/AryanSarafDev/CertiFy/assets/96824236/6c4e53f3-736b-4809-9c0f-8aeef71e685b



## Video Demonstration
Link to youtube video demonstration👇

[![Video](https://img.youtube.com/vi/Ry7EyGamQA0/0.jpg)](https://www.youtube.com/watch?v=Ry7EyGamQA0)
## Inspiration

CertiFy was inspired by the urgent need to address the issue of counterfeit certificates. The traditional verification process is time-consuming and bureaucratic, and the involvement of intermediaries can lead to corruption.

Our platform demonstrates that combining blockchain technology with Supabase's powerful features can provide a secure and transparent solution to this pressing problem.

### NOTE:

**We have currently deployed this using a local blockchain through Truffle and Ganache. We haven't deployed it on the mainnet because we are both students who lack the necessary funds for proper deployment.**

## Description & Process

The application has 2 main components: Organization and Person.

#### Certificate Issuing

* The organizer can issue certificates (currently only in PDF) to a registered person using their email.
    
* The certificates issued to a person can be viewed on their screen along with the name of the organization that issued the certificate.
    
* When a certificate is issued, the hash of the student email, organization email, and a hash of PDF contents is computed.
    
* These details are then stored on the blockchain using our smart contract and the corresponding transaction hash is stored on Supabase's database. The pdf itself is stored on Supabase's storage for downloading it in the future.
    
* The transaction hash will make it possible for anyone to verify the authenticity manually by entering the hash into a website such as [https://getblock.io](https://getblock.io) (blockchain explorers).
    
#### Certificate Verification
    
* Each certificate detail stored on the blockchain has an additional boolean variable called `isRevoked` associated with it.
    
* When a certificate issued by the organization is deleted, the details & file stored on Supabase is deleted.
    
* We modify this variable on the blockchain to `true` indicating this particular certificate has been revoked. This preserves the immutability of the blockchain.
    
* In the certificate verification screen, the user has to enter all the student email, and organization email and upload the original PDF.
    
* We recompute the hashes and use the smart contract to check f such a certificate is stored and if it is not revoked. If all these conditions match, we return true, indicating the certificate is valid.
    
* For every valid certificate, we will also show the corresponding transaction hash so a user can manually verify using blockchain explorers.
    
## How We've Utilized Supabase!

* We've utilized Supabase's authentication system to enable organizations and users to sign up. In our opinion, this is one of the most impressive features provided by Supabase, as it was incredibly fast and simple to set up.

* We store user and certificate details using Supabase's database. This enables us to export a schema, encouraging others to self-host and support open source!

* Additionally, we store every PDF uploaded by users using Supabase's storage. This feature enables us to swiftly facilitate certificate downloads for users in the future. Conventionally, this process would require extensive server-side setup, but Supabase has made it hassle-free!

## Installation

To install and run this project locally, you need to have Flutter, Truffle, Ganache, Node.js with npm installed on your machine.

1. Clone this repository: [`https://github.com/AryanSarafDev/certify.git`](https://github.com/AryanSarafDev/certify.git)
    
2. Navigate to `lib/contracts`
    
3. Install dependencies using `npm install`
    
4. Start Ganache and create a workspace with your project folder and add `lib/contracts/truffle-config.js` in workspace.

![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/install_1.jpg)
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/install_2.jpg)
    
5. Open the `.env file` and enter the appropriate details as listed below.
    
6. Copy your `private key address` from Ganache and paste it for `PRIVATE_KEY`
    
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/install_3.jpg)
![screen.jpg](https://github.com/AryanSarafDev/certify/blob/master/screenshots/install_4.jpg)
    
7. Create a Supabase project and copy your `API URL` and `public key` from `Settings > API` and paste it for `SUPABASE_URL & SUPABASE_KEY`
    
8. Create two tables called `everyone` (which stores user details) and `organization` (which stores the issued certificate details) using the following schema code:
    
    #### everyone:
    
    ```dart
    create table
      public.everyone (
        id bigint generated by default as identity not null,
        created_at timestamp with time zone null default now(),
        uid text not null default ''::text,
        username text not null default ''::text,
        isorg boolean null default false,
        isper boolean null default false,
        oid text null default ''::text,
        email text null default ''::text,
        constraint everyone_pkey primary key (id)
      ) tablespace pg_default;
    ```
    
    #### organization:
    
    ```dart
    create table
      public.organization (
        id bigint generated by default as identity not null,
        created_at date null,
        email text null default ''::text,
        certificate text null default ''::text,
        uid text null default ''::text,
        oid text null default ''::text,
        certname text null default ''::text,
        orgname text null default ''::text,
        hashval text null,
        filename text null default ''::text,
        orgemail text null default ''::text,
        transhash text null,
        constraint organization_pkey primary key (id)
      ) tablespace pg_default;
    ```
    
9. Compile and deploy the smart contract by opening the terminal at `lib/contracts` : `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` , `truffle compile` and `truffle migrate`
    
10. Run the app on your emulator and enjoy!
    

## Usage

To use this app as an organizer or a person, you need to sign up with your email and password using Supabase Auth.

### As an organizer

* You can create certificates by filling out a form with the student's email and uploading a pdf file of the certificate.
    
* You can view all the certificates you have issued in a list.
    
* You can revoke or delete any certificate you have issued by clicking on the corresponding buttons in the table.
    

### As a person

* You can view all the certificates you have received in a list with their details.
    
* You can download any certificate you have received by clicking on the download button in the table.
    

### As anyone

* You can verify any certificate by entering its student email, organization email, and certificate hash.
    
* You can see if the certificate is valid or not based on the result of verifying its hashes using blockchain technology.




## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## Contributors

This project was created by:

* Aryan Saraf - [GitHub](https://github.com/aryansarafdev) | [Twitter](https://twitter.com/Gold_24_Gold?s=20) | [LinkedIn](https://www.linkedin.com/in/aryan-saraf-43791524b/)
    
* Rijuth Menon - [GitHub](https://github.com/MarkisDev) | [Twitter](https://twitter.com/markisdev) | [LinkedIn](https://linkedin.com/in/rijuthmenon)
