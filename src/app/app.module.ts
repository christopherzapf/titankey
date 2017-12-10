import { AppRoutingModule } from './app.routes';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { CollapseDirective } from 'ngx-bootstrap';

import { AppComponent } from './app.component';
import { HeaderComponent } from './header/header.component';
import { CreateComponent } from './create/create.component';
import { NoContentComponent } from './no-content/no-content.component';
import { StartComponent } from './start/start.component';
import { ProfileComponent } from './profile/profile.component';
import { SearchComponent } from './search/search.component';
import { SendComponent } from './send/send.component';

@NgModule({
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpModule,
    AppRoutingModule
  ],
  declarations: [
    AppComponent,
    HeaderComponent,
    CreateComponent,
    NoContentComponent,
    CollapseDirective,
    StartComponent,
    ProfileComponent,
    SearchComponent,
    SendComponent
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
