# Block Poll

## What is this project about?

Block Poll is a decentralised web 3.0 based online voting system which allow voters to vote securely and anonymously while maintaining privacy and transparency.

## Project Framework

* __Frontend__ : React JS
* __BlockChain__ : Sepolia Testnet
* __Contract/Backend__ : Solidity
* __IPFS__ : Infura
* __Contract Management__ : Truffle

## Project Features

* Role Based Authorization
* Separate Dashboards for Voter/Admin
* TOTP 2FA with Google Authenticator
* Unique Password 🔑 Generation for addresses
* Unique Setup Key Generator for addresses for connection to Google Authenticator
* QR Code for scanning key directly into Google Authenticator 
* Decentralised file storage using Infura
* Communication with blockchain via Metamask

## Admin Login Test Data <br>
```
* Install Metamask to connect account with for login and registration.
* Browse to localhost:port/adminApp/adminLogin <br> Note : THIS PAGE IS ACCESSIBLE ONLY IF WALLET ADDRESS IS GIVEN ADMIN RIGHTS
* Aadhar ID : 000000000000
* Login Key
```text
d%4c50e2dbA5&ed&dd90U&2d-R]73d1]Wc73+54u9bKx45672ib26f0p1Nmk_+20cpdC(b5712
```
* Google Authenticator Setup Key
```bash
MRSDSMCVGJSFENZT
```
* Enter client directory
```bash
cd client
```
* Install dependencies
```npm
npm install
```
* Run Project for development 
```npm
npm run dev
```
* Run Project for production
```npm
npm run build
npm start
```