import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { QnAPage } from './qn-a';

@NgModule({
  declarations: [
    QnAPage,
  ],
  imports: [
    IonicPageModule.forChild(QnAPage),
  ],
})
export class QnAPageModule {}


