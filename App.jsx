import React, { useState, useEffect } from 'react';
];


function App() {
const [provider, setProvider] = useState(null);
const [signer, setSigner] = useState(null);
const [account, setAccount] = useState(null);
const [answer, setAnswer] = useState('');
const [metadataHash, setMetadataHash] = useState('');
const [status, setStatus] = useState('');


useEffect(() => {
if (window.ethereum) {
const p = new ethers.providers.Web3Provider(window.ethereum);
setProvider(p);
}
}, []);


async function connect() {
const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
setAccount(accounts[0]);
const s = provider.getSigner();
setSigner(s);
}


async function submit() {
setStatus('Submitting...');
// NOTE: You may want to normalize the answer (lowercase, trim) in front-end before sending
const chapter = new ethers.Contract(CHAPTER_ADDRESS, CHAPTER_ABI, signer);
try {
const tx = await chapter.submitAnswer(answer, metadataHash);
setStatus('Transaction sent — waiting for confirmation');
await tx.wait();
setStatus('Submitted — check events or your wallet for minted NFT');
} catch (e) {
setStatus('Error: ' + (e.message || e));
}
}


return (
<div style={{ padding: 24, fontFamily: 'sans-serif' }}>
<h1>Cipher Protocol — Submit Answer</h1>
{!account ? (
<button onClick={connect}>Connect Wallet</button>
) : (
<div>Connected: {account}</div>
)}


<div style={{ marginTop: 16 }}>
<label>Answer (normalize before sending
