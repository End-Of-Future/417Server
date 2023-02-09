--圣光-守望之碑
function c27819012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,27819012) 
	e2:SetCost(c27819012.xxcost) 
	e2:SetTarget(c27819012.xxtg)  
	e2:SetOperation(c27819012.xxop) 
	c:RegisterEffect(e2) 
end 
c27819012.SetCard_XXLight=true 
function c27819012.xxcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,500) end 
	Duel.PayLPCost(tp,500) 
end 
function c27819012.ckfil(c) 
	return c.SetCard_XXLight and (not c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup())
end 
function c27819012.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c27819012.ckfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE) 
end 
function c27819012.tdfil(c,ctype) 
	if ctype==0 then return false end 
	return c.SetCard_XXLight and (not c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup()) and c:IsType(ctype) and c:IsAbleToDeck() 
end 
function c27819012.xsxfil(c,sg)
	return sg:IsContains(c) 
end 
function c27819012.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local opt=e:GetLabel() 
	local ctype=0 
	if opt==0 then ctype=TYPE_MONSTER end 
	if opt==1 then ctype=TYPE_SPELL end 
	if opt==2 then ctype=TYPE_TRAP end 
	local g=Duel.GetMatchingGroup(c27819012.tdfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,ctype) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,3,nil) 
	local x=Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
	Duel.ShuffleDeck(tp) 
	if x>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=x then 
	local hg=Duel.GetDecktopGroup(tp,x)   
	Duel.ConfirmDecktop(tp,x) 
	local gg=hg:Filter(c27819012.xsxfil,nil,sg)
	if gg:GetCount()>0 then 
	 if opt==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=gg:GetCount() and gg:GetCount()==gg:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false) then 
	 Duel.SpecialSummon(gg,0,tp,tp,false,false,POS_FACEUP) 
	 end 
	 if opt==1 and gg:GetCount()==gg:FilterCount(Card.IsAbleToHand,nil) then 
	 Duel.SendtoHand(gg,tp,REASON_EFFECT) 
	 Duel.ConfirmCards(1-tp,gg) 
	 end 
	 if opt==2 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=gg:GetCount() and gg:GetCount()==gg:FilterCount(Card.IsSSetable,nil) then  
	 Duel.SSet(tp,gg) 
	 local tc=gg:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)   
		tc=gg:GetNext() 
		end 
	 end 
	end 
	end 
	end 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(27819012,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)  
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT) 
	e1:SetLabel(Duel.GetTurnCount(),ctype)
	e1:SetCountLimit(1,17819012) 
	e1:SetTarget(c27819012.thtg)
	e1:SetOperation(c27819012.thop) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)  
end 
function c27819012.thfil(c,ctype) 
	if ctype==0 then return false end 
	return c.SetCard_XXLight and c:IsType(ctype) and c:IsAbleToHand()
end
function c27819012.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local turn,ctype=e:GetLabel() 
	if chk==0 then return Duel.GetTurnCount()==turn and e:GetHandler():IsReason(REASON_EFFECT) and Duel.IsExistingTarget(c27819012.thfil,tp,LOCATION_GRAVE,0,1,nil,ctype) end 
	local g=Duel.SelectTarget(tp,c27819012.thfil,tp,LOCATION_GRAVE,0,1,1,nil,ctype)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c27819012.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc)
	end
end














