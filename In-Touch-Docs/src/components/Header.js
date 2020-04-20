import React from 'react'
import { Navbar, Nav, Col } from 'react-bootstrap'
import github from '../images/github.png'
import { useLocation } from 'react-router-dom'
import "./Header.css";

const Header = () => {
    let location = useLocation();
    return (
    <Navbar bg="dark" variant="dark">
        <Navbar.Brand href="/">In Touch</Navbar.Brand>
        <Nav id="headerbar"  defaultActiveKey={typeof location === 'undefined'? null:location.pathname}>
            <Nav.Link href="/getting-started">Getting Started</Nav.Link>
            <Nav.Link href="/backend">Backend</Nav.Link>
            <Nav.Link href="/flutter">Flutter</Nav.Link>
        </Nav>
        <div className="mr-auto"></div>
        <Nav.Link href="https://github.com/In-Touch-Hackathon"><img alt="Github" height={24} src={github}></img></Nav.Link>
    </Navbar>)
}

export default Header