A Readme is a document that provides essential information about a project, such as its name, description, features, installation, usage, license, and contributors. A Readme helps potential users and developers to understand what the project is about and how to use it.

Here is an example of a Readme for your project, using markdown syntax:

# CertiFy

CertiFy is a blockchain-backed certificate verification app. The inspiration for such an app came from the immediate need to curb the fake certificates that can be easily made with decent skills.

The conventional process of verify certificates usually involves lots of bureaucracy and that involves a lot of time.

Our system is proof that blockchain coupled with Supabase's awesome features can help solve this issue.

We've currently deployed this using a local blockchain using Truffle and Ganace. But we're very confident that we can migrate this to the mainnet (actual blockchain like Ethereum or Polygon) within a couple steps.

## Features

The app has 2 main components: The organizer and the person.

- The organizer can issue certificates (currently in pdf) to a person using their email.
- The certificates issued to a person can be viewed in their screen and also the name of organization issuing it will be seen.
- The smart contract (written using Solidity) is used to run on any EVM (Ethereum Virtual Machine) compatible blockchain.
- When a certificate is added, the hash of the student email, org email and a hash of the pdf contents is computed. These details are stored on SupaBase and the pdf itself is stored on SupaBase storage.
- We also store these hash on the blockchain using the smart contract and the corresponding transaction hash is stored on SupaBase.
- The transaction hash makes it possible for anyone to verify the authenticity manually by entering the hash into a website such as getblock.io (blockchain explorers).
- Each certificate has an extra variable in the smart contract to denote if the certificate is revoked or not.
- When the certificate issued by an org is deleted by the org, the entry is removed from db and file is also deleted.
- We modify the certificate details on blockchain by setting the revoked variable to true.
- Whenever verify certificate is called, our contract returns true if a certificate hash for a particular organisation is linked to a participant student's hash.
- If such a certificate exists and the revoked is false, then the function returns true indicating the certificate is valid.
- In the Verify screen that anyone can open, the user has to enter all the details linked to the certificate. The hashes are computed again and checked using the verify function which reads the data from blockchain and returns a Boolean value.
- For every valid certificate, we will also show the corresponding hash so a user can manually verify.

## Installation

To install and run this project locally, you need to have Truffle, Ganache, Node.js, npm, and Supabase installed on your machine.

1. Clone this repository: `git clone https://github.com/yourusername/CertiFy.git`
2. Navigate to the project folder: `cd CertiFy`
3. Install dependencies: `npm install`
4. Start Ganache and create a workspace with your project folder.
5. Compile and deploy the smart contract: `truffle migrate --reset`
6. Copy your contract address from Ganache and paste it in `src/config.js`
7. Create a Supabase project and copy your API URL and public key from Settings > API and paste them in `src/config.js`
8. Create a table named `certificates` in Supabase with the following columns: `id`, `student_email`, `org_email`, `cert_hash`, `tx_hash`, `file_url`.
9. Start the development server: `npm start`
10. Open http://localhost:3000 in your browser and enjoy!

## Usage

To use this app as an organizer or a person, you need to sign up with your email and password using Supabase Auth.

### As an organizer

- You can create certificates by filling out a form with the student's email and uploading a pdf file of the certificate.
- You can view all the certificates you have issued in a table with their details and status (valid or revoked).
- You can revoke or delete any certificate you have issued by clicking on the corresponding buttons in the table.

### As a person

- You can view all the certificates you have received in a table with their details and status (valid or revoked).
- You can download any certificate you have received by clicking on the download button in the table.

### As anyone

- You can verify any certificate by entering its student email, org email, cert hash, and tx hash in a form.
- You can see if the certificate is valid or not based on the result of verifying its hashes on both Supabase and blockchain.

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## Contributors

This project was created by:

- Your name
- Your teammate's name