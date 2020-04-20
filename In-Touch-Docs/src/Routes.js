import React from 'react'
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import Home from './pages/Home'
import DocsLayout from './layout/Docs'

import { Introduction, Twilio, Firebase, Backend, Flutter } from './pages/getting-started'
import { BackendIntro, ProjectNode, Handlers, Covid19, TwilioIVR, Firestore } from './pages/backend'
import { FeaturesPages, FlutterIntro, HowToUse, ProjectFlutter } from './pages/flutter'

const Routes = () => {
    return (
        <Router>
            <Switch>
                <Route exact path="/" component={Home} />
                <Route path="/getting-started">
                    <DocsLayout>
                        <Route exact path="/getting-started" component={Introduction} />
                        <Route exact path="/getting-started/twilio" component={Twilio} />
                        <Route exact path="/getting-started/firebase" component={Firebase} />
                        <Route exact path="/getting-started/backend" component={Backend} />
                        <Route exact path="/getting-started/flutter" component={Flutter} />
                    </DocsLayout>
                </Route>
                <Route path="/backend">
                    <DocsLayout>
                        <Route exact path="/backend" component={BackendIntro} />
                        <Route exact path="/backend/project" component={ProjectNode} />
                        <Route exact path="/backend/handlers" component={Handlers} />
                        <Route exact path="/backend/covid19" component={Covid19} />
                        <Route exact path="/backend/twilio" component={TwilioIVR} />
                        <Route exact path="/backend/firestore" component={Firestore} />
                    </DocsLayout>
                </Route>
                <Route path="/flutter">
                    <DocsLayout>
                        <Route exact path="/flutter" component={FlutterIntro} />
                        <Route exact path="/flutter/how-to-use" component={HowToUse} />
                        <Route exact path="/flutter/pages" component={FeaturesPages} />
                        <Route exact path="/flutter/project" component={ProjectFlutter} />
                    </DocsLayout>
                </Route>
            </Switch>
        </Router>
    )
}

export default Routes