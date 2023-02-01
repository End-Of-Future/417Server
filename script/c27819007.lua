--正义呼唤
function c27819007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,27819007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27819007.target)
	e1:SetOperation(c27819007.activate)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_CUSTOM+27819007)
	e2:SetCost(c27819007.thcost)
	e2:SetTarget(c27819007.thtg)
	e2:SetOperation(c27819007.thop)
	c:RegisterEffect(e2)
end 
c27819007.SetCard_XXLight=true 
function c27819007.filter(c,e,tp)
	return c.SetCard_XXLightDragon and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27819007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27819007.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c27819007.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c27819007.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c27819007.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(27819007,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_LEAVE_FIELD) 
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetOperation(c27819007.msop) 
	tc:RegisterEffect(e1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27819007.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c27819007.splimit(e,c)
	return not c.SetCard_XXLight and not c:IsCode(27819034) 
end
function c27819007.msop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+27819007,e,0,0,tp,0) 
	e:Reset()
end 
function c27819007.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	g:AddCard(e:GetHandler()) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end 
function c27819007.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c.SetCard_XXLight 
end 
function c27819007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,ckhc) 
	if chk==0 then return Duel.IsExistingTarget(c27819007.thfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end  
	local g=Duel.SelectTarget(tp,c27819007.thfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
end 
function c27819007.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.SendtoHand(tc,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,tc)
	end 
end 












