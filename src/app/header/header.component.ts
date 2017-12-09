import { Component, OnInit } from '@angular/core';

@Component({
	selector: 'titankey-header',
	templateUrl: './header.component.html',
	styleUrls: [ './header.component.scss' ]
})
export class HeaderComponent implements OnInit {
	public isCollapsed: boolean = true;
	
	constructor() {}

	ngOnInit() {}
}
