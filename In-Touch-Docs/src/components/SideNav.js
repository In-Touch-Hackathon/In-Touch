import React from 'react'
import { Nav, Navbar, Col, Row, FormControl } from 'react-bootstrap'
import "./SideNav.css";
import { useLocation } from 'react-router-dom'

const SideNav = () => {
    let location = useLocation();
    let pathname = typeof location === 'undefined' ? "" : location.pathname;
    const check = (path) => pathname.startsWith(path)
    return (
        <Navbar className="sidenav" expand="sm" style={{ padding: 0, width: "100%" }}>
            <Col style={{ padding: 0, height: "100%" }}>
                <Row style={{ marginLeft: 5, marginRight: 5, padding: 5, paddingBottom: 20 }}>
                    <Col style={{ padding: 0, paddingRight: 10 }}>
                        <FormControl
                            style={{ background: 0, borderWidth: 0, borderBottomWidth: 1, borderRadius: 0, borderBottomColor: '#212529', color: '#212529' }}
                            type="text"
                            placeholder=""
                        />
                    </Col>
                    <Navbar.Toggle aria-controls="basic-navbar-nav" />
                </Row>
                <Navbar.Collapse style={{ padding: 0 }} id="basic-navbar-nav">
                    <Nav className="flex-column" defaultActiveKey={pathname}>
                        <Nav.Link href="/getting-started" >Getting Started</Nav.Link>
                        {check("/getting-started")?<Col>
                            <Nav.Link href="/getting-started/twilio" >Setup Twilio</Nav.Link>
                            <Nav.Link href="/getting-started/firebase" >Setup Firebase</Nav.Link>
                            <Nav.Link href="/getting-started/backend" >Setup Backend</Nav.Link>
                            <Nav.Link href="/getting-started/flutter" >Setup Flutter</Nav.Link>
                        </Col>:null}
                        <Nav.Link href="/backend">Backend</Nav.Link>
                        {check("/backend")?<Col>
                            <Nav.Link href="/backend/project" >Project Structure</Nav.Link>
                            <Nav.Link href="/backend/handlers" >Handlers</Nav.Link>
                            <Nav.Link href="/backend/covid19" >Covid19 Update</Nav.Link>
                            <Nav.Link href="/backend/twilio" >Twilio IVR</Nav.Link>
                            <Nav.Link href="/backend/firestore" >Firestore</Nav.Link>
                        </Col>:null}
                        <Nav.Link href="/flutter">Flutter</Nav.Link>
                        {check("/flutter")?<Col>
                            <Nav.Link href="/flutter/how-to-use" >How to use</Nav.Link>
                            <Nav.Link href="/flutter/pages" >Features/Pages</Nav.Link>
                            <Nav.Link href="/flutter/project" >Project Structure</Nav.Link>
                        </Col>:null}
                    </Nav>
                </Navbar.Collapse>
            </Col>
        </Navbar >
    )
}

export default SideNav