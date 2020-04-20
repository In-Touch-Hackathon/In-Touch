import React from 'react'
import { Container, Col, Row } from 'react-bootstrap'
import SideNav from '../components/SideNav'


const DocsLayout = ({children}) => {
    return (
        <Container fluid style={{height: "100%", minHeight: "calc(100vh - 58px)"}}>
            <Row style={{height: "auto"}}>
                <Col xs={12} md={3} xl={2} style={{background: "#FCFCFC"}}>
                    <SideNav/>
                </Col>
                <Col 
                    style={{ height: "100%", minHeight: "calc(100vh - 58px)", padding: 20}}
                    xs={12}
                    md={9}
                    xl={8}
                >
                    {children}
                </Col>
                <Col xl={2} style={{height: "100%"}}/>
            </Row>
        </Container>
    )
}

export default DocsLayout