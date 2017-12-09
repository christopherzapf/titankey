import { SendComponent } from './send/send.component';
import { SearchComponent } from './search/search.component';
import { ProfileComponent } from './profile/profile.component';
import { StartComponent } from './start/start.component';
import { CreateComponent } from './create/create.component';
import { Routes, RouterModule } from '@angular/router';
import { NgModule } from '@angular/core';
import {NoContentComponent} from './no-content/no-content.component';

export const appRoutes: Routes = [
  { path: '', component: StartComponent },
  { path: 'create', component: CreateComponent},
  { path: 'profile', component: ProfileComponent},
  { path: 'search', component: SearchComponent},
  { path: 'send', component: SendComponent},
  { path: '**',    component: NoContentComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(appRoutes)],
  exports: [RouterModule],
  providers: [
  ]
})
export class AppRoutingModule {}
