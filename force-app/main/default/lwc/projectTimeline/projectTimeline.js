import { LightningElement, api, wire } from 'lwc';
import getProjectsForAccount from '@salesforce/apex/ProjectController.getProjectsForAccount';
import noProjects from '@salesforce/label/c.No_Projects_Found';

export default class ProjectTimeline extends LightningElement {
    @api recordId;
    label = { noProjects };
    projects = [];

    @wire(getProjectsForAccount, { accountId: '$recordId' })
    wiredProjects({ data, error }) {
        if (data) {
            this.projects = data.map((p) => ({ ...p, url: `/lightning/r/Project__c/${p.Id}/view` }));
        } else if (error) {
            // eslint-disable-next-line no-console
            console.error('Failed to load projects', error);
        }
    }

    get hasProjects() {
        return this.projects.length > 0;
    }
}
