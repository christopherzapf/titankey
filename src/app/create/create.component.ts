import { Component, OnInit, ViewChild } from '@angular/core';
import { AbstractControl, FormBuilder, FormControl, FormGroup, NgForm, Validators } from '@angular/forms';
import { CollapseDirective } from 'ngx-bootstrap';

import { Observable } from 'rxjs';

@Component({
	selector: 'app-create',
	templateUrl: './create.component.html',
	styleUrls: [ './create.component.scss' ]
})
export class CreateComponent implements OnInit {
	reactiveForm: FormGroup;

	showForm: boolean = true;
	showLoadingIndicator: boolean = false;

	privateKey: string;
	publicKey: string;

	@ViewChild('ngForm') ngForm: NgForm;

	constructor(private fb: FormBuilder) {}

	ngOnInit() {
		this.reactiveForm = this.fb.group({
			email: [
				'',
				[
					Validators.required,
					Validators.pattern(
						/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
					)
				]
			]
		});
	}

	createAccount() {
		this.showLoadingIndicator = true;
		Observable.if(
			() => this.reactiveForm.get('email').value !== 'quiringuthmann@quikus.de',
			Observable.of(this.reactiveForm.get('email').value),
			Observable.throw('Email already in use.')
		).subscribe(
			(email) => {
				console.log(email);
				this.showForm = false;
				this.privateKey = 'epouefbpasidiufbpaisfbaisdfbapsidbapiwudbapwidubawdipub';
				this.publicKey = 'aöiijsfbapisjcnuosdcbuspdujgbvspifujvbuspidivubspiduvjb';
				this.showLoadingIndicator = false;
			},
			() => {
				this.showLoadingIndicator = false;
			}
		);
	}

	getError(id: string) {
		if (this.ngForm && this.ngForm.submitted) {
			return 'The email is already used. Please use another email.';
		}
	}
}
