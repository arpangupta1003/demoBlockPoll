import React from 'react';
import imgPath from '../../assets/bg.jpg';
import { SiLinkedin } from "react-icons/si";


const persons = [
  { 
    name: 'Arpan Gupta', 
    education: 'Bachelor of Science in Computer Science', 
    university: 'Ajay Kumar Garg Engineering College',
    linkedin: 'https://www.linkedin.com/in/arpan-gupta-918822202/'
  },
  { 
    name: 'Aradhya Mittal', 
    education: 'Bachelor of Science in Computer Science', 
    university: 'Ajay Kumar Garg Engineering College',
    linkedin: 'https://www.linkedin.com/in/aradhya-mittal-101b0920b/'
  },
  { 
    name: 'Afzal Bux', 
    education: 'Bachelor of Science in Computer Science', 
    university: 'Ajay Kumar Garg Engineering College',
    linkedin: 'https://www.linkedin.com/in/afzal-bux-021461212/'
  },
  { 
    name: 'Aryan Sharma', 
    education: 'Bachelor of Science in Computer Science', 
    university: 'Ajay Kumar Garg Engineering College',
    linkedin: 'https://www.linkedin.com/in/aryan-sharma-171b0b204/'
  }
];

const PersonCard = ({ name, education, university, linkedin, isLeft }) => (
  <div style={isLeft ? styles.leftCard : styles.rightCard}>
    <strong style={{ fontSize: "1.3em" }}><h1 style={styles.name}>{name}</h1></strong>
    <p style={styles.detail}><strong>Education:</strong> {education}</p>
    <p style={styles.detail}><strong>University:</strong> {university}</p>
     <a href={linkedin} target="_blank" rel="noopener noreferrer"><SiLinkedin style={{fontSize:"2em"}}/></a>
  </div>
);

const PersonList = () => (
  <div style={styles.container}>
    {persons.map((person, index) => (
      <PersonCard
        key={index}
        {...person}
        isLeft={index % 2 === 0} // Alternating left-right combination
      />
    ))}
  </div>
);

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    padding: '20px',
    backgroundImage: `url(${imgPath})`, // Background image
    backgroundSize: 'cover',
    backgroundRepeat: 'no-repeat',
    backgroundPosition: 'center',
    minHeight: '100vh',
    width: '100%',
    boxSizing: 'border-box'
  },
  leftCard: {
    width: '25%',
    padding: '20px',
    border: '1px solid #ccc',
    borderRadius: '5px',
    backgroundColor: '#fff',
    marginBottom: '20px',
    marginRight: '250px'
  },
  rightCard: {
    width: '25%',
    padding: '20px',
    border: '1px solid #ccc',
    borderRadius: '5px',
    backgroundColor: '#fff',
    marginBottom: '20px',
    marginLeft: '250px'
  },
  name: {
    marginBottom: '10px',
    color: '#333'
  },
  detail: {
    marginBottom: '5px'
  }
};

export default PersonList;
