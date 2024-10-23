import ISubscriptionRepository "../repositories/ISubscriptionRepository";
import IEventNotificationRepository "../repositories/IEventNotificationRepository";
import IIcpService "../interfaces/IIcpService";
import IEmailRepository "../repositories/IEmailRepository";

import PublishEvent "PublishEventUseCase";
import ReceiveEventNotification "ReceiveEventNotificationUseCase";
import GetEventNotifications "GetEventNotificationsUseCase";
import UnsubscribeEvent "UnsubscribeEventUseCase";
import SaveInboundEmail "SaveInboundEmailUseCase";
import SubscribeNamespace "SubscribeNamespaceUseCase";
import GetAllSubscriptions "GetAllSubscriptionsUseCase";

module {
    public class UsecaseFactory(
        emailRepository : IEmailRepository.IEmailRepository,
        subscriptionRepository : ISubscriptionRepository.ISubscriptionRepository,
        eventNotificationRepository : IEventNotificationRepository.IEventNotificationRepository,
        icpService : IIcpService.IIcpService,
    ) {
        public func createPublishEventUseCase() : PublishEvent.PublishEventUseCase {
            PublishEvent.PublishEventUseCase(icpService);
        };

        public func createReceiveEventNotificationUseCase() : ReceiveEventNotification.ReceiveEventNotification {
            ReceiveEventNotification.ReceiveEventNotification(eventNotificationRepository);
        };

        public func createGetEventNotificationsUseCase() : GetEventNotifications.GetEventNotifications {
            GetEventNotifications.GetEventNotifications(eventNotificationRepository);
        };

        public func createSubscribeNamespaceUseCase() : SubscribeNamespace.SubscribeNamespaceUseCase {
            SubscribeNamespace.SubscribeNamespaceUseCase(subscriptionRepository, icpService);
        };

        public func createUnsubscribeEventUseCase() : UnsubscribeEvent.UnsubscribeEvent {
            UnsubscribeEvent.UnsubscribeEvent(subscriptionRepository);
        };
        public func createSaveInboundEmailUseCase() : SaveInboundEmail.SaveInboundEmailUseCase {
            SaveInboundEmail.SaveInboundEmailUseCase(emailRepository);
        };
        public func createGetAllSubscriptionsUseCase() : GetAllSubscriptions.GetAllSubscriptionsUseCase {
            GetAllSubscriptions.GetAllSubscriptionsUseCase(subscriptionRepository);
        };
    };
};
