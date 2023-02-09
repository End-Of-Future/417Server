--王牌竞赛 双子
function c88880528.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd88),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--search 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e1:SetTarget(c88880528.srtg)
	e1:SetOperation(c88880528.srop)
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(88880528,1))
	e2:SetCategory(CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88880528)  
	e2:SetTarget(c88880528.rmtg) 
	e2:SetOperation(c88880528.rmop) 
	c:RegisterEffect(e2) 
	--des and rm 
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(88880528,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,88880528)  
	e3:SetTarget(c88880528.drmtg) 
	e3:SetOperation(c88880528.drmop) 
	c:RegisterEffect(e3) 
end
function c88880528.srfil(c)
	return c:IsSetCard(0xd88) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c88880528.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880528.srfil,tp,LOCATION_DECK,0,1,nil) end
end
function c88880528.srop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c88880528.srfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c88880528.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local x1=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) 
	local x2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) 
	if chk==0 then return x1>0 and x2>0 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end 
function c88880528.rmop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local x1=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) 
	local x2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) 
	if x1>0 and x2>0 then 
		if x1>x2 then x1=x2 end 
		local xt={} 
		local b=1
		for a=1,x1 do 
			xt[b]=a 
			b=b+1 
		end 
		local x=Duel.AnnounceNumber(tp,table.unpack(xt)) 
		local g=Duel.GetDecktopGroup(1-tp,x) 
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)   
	end 
end  
function c88880528.drmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,4,nil) and Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end 
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,1-tp,LOCATION_DECK) 
end 
function c88880528.drmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,4,nil) then 
		Duel.BreakEffect() 
		local g=Duel.GetDecktopGroup(1-tp,4) 
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end 
end 


