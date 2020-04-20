import React from 'react'
import { Container, Row, Col, Button } from 'react-bootstrap'

const Home = () => {
    return (
        <Container>
            <Row style={{maxWidth: 900, margin: 'auto', paddingTop: 50, paddingBottom: 50}}>
                <Col>
                    <h1>In Touch</h1>
                    <p style={{fontSize: '25px'}}>A responsive, scalable and configurable service that allows the vulnerable elderly to get in touch with volunteers.</p>

                    <Button variant="outline-primary" href="/getting-started" style={{width: 150, padding: 5, marginRight: 10}}>Get Started</Button>
					<Button variant="outline-secondary" style={{width: 150, padding: 5, marginRight: 10}} href="/backend">Backend</Button>
					<Button variant="outline-secondary" style={{width: 150, padding: 5}} href="/flutter">Flutter App</Button>

                </Col>
            </Row>
            <Row>
                <Col sm={4} xs={12} >
                    <p style={{fontSize: '28px'}}>Built with Twilio</p>
                    <p>This project is built using Twilio, making the setup and customisation easy. Twilio handles all the complicated hardware required to connect phone numbers to the cloud which allows In-Touch to focus on what is important.</p>
                </Col>
                <Col sm={4} xs={12} >
                    <p style={{fontSize: '28px'}}>Built with Firebase</p>
                    <p>Project uses Firebase authentication and Firestore. This give us support for multiple platforms and makes adding new features easy. The Firebase authentication SDK can make adding the features like Google and Facebook Login easy.</p>
                </Col>
                <Col sm={4} xs={12} >
                    <p style={{fontSize: '28px'}}>Skillsme Hackathon</p>
                    <p>This project is made for the 2020 Skillsme Hackathon with the mentality to help people during the COVID-19 epidemic.</p>
                </Col>
            </Row>
        </Container>
    )
}
export default Home