--战华之妖-神郭嘉
local m=10703006
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_BEASTWARRIOR),5,5)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,m)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,2))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,m)
    e5:SetCondition(cm.thcon)
    e5:SetTarget(cm.thtg)
    e5:SetOperation(cm.thop)
    c:RegisterEffect(e5)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
    local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(cm.qjcon)
	e7:SetValue(cm.qjval)
	c:RegisterEffect(e7)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,3))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
    e1:SetTarget(cm.thtg2)
    e1:SetOperation(cm.thop2)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
    e3:SetCountLimit(1,m+1+EFFECT_COUNT_CODE_DUEL)
    e3:SetCondition(cm.thcon3)
    e3:SetOperation(cm.thop3)
    c:RegisterEffect(e3)
    if not cm.global_check then
        cm.global_check=true
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e3:SetCode(EVENT_DAMAGE)
        e3:SetOperation(cm.tyck)
        Duel.RegisterEffect(e3,tp)
    end
end

function cm.tyck(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(ep,m)==0 then
        Duel.RegisterFlagEffect(ep,m,0,0,1)
    end
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<=18000
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local dct=Duel.GetFieldGroupCount(tp,0x01,0)
        local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
        return dct~=0 and tc:IsAbleToHand()
    end
    Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_DECK)
end


function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local dct=Duel.GetFieldGroupCount(tp,0x01,0)
    if dct==0 then return false end
    local j=0
    local g=Group.CreateGroup()
    for i=1,math.min(dct,5) do
        Duel.DisableShuffleCheck()
        Duel.ConfirmDecktop(tp,1)
        local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
        if tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_PENDULUM) or tc:IsType(TYPE_EQUIP) then
            j=j+1
        elseif tc:IsType(TYPE_MONSTER) then j=j+10
        elseif tc:IsType(TYPE_SPELL) then j=j+100
        elseif tc:IsType(TYPE_TRAP) then j=j+1000
        end
        g:AddCard(tc)
        Duel.Recover(tp,2000,REASON_EFFECT)
        if j%10==2 or j%100//10==2 or j%1000//100==2 or j//1000==2 then break end
        if Duel.GetLP(tp)>18000 then break end
        Duel.MoveSequence(tc,1)
    end
    local g2=g:Filter(Card.IsAbleToHand,nil)
    if Duel.SendtoHand(g2,tp,REASON_EFFECT) then
        Duel.ConfirmCards(1-tp,g2)
        Duel.ShuffleHand(tp)
        if Duel.GetFieldGroupCount(tp,0x02,0)>=Duel.GetFieldGroupCount(tp,0,0x02) then
            Duel.BreakEffect()
            Duel.SetLP(tp,Duel.GetLP(tp)-2000)
        end
    end
    Duel.ShuffleDeck(tp)
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return ((Duel.CheckLPCost(tp,2000) and c:IsReason(REASON_BATTLE)) or (Duel.GetLP(tp)>6000 and c:IsReason(REASON_EFFECT))) and not c:IsReason(REASON_REPLACE) end
	if c:IsReason(REASON_BATTLE) then
        return Duel.SelectEffectYesNo(tp,c,aux.Stringid(10703000,1))
    else
        return Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,1))
    end
end

function cm.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler() 
    if c:IsReason(REASON_BATTLE) then
	    Duel.PayLPCost(tp,2000)
    else
        Duel.SetLP(tp,Duel.GetLP(tp)-2000)
    end
end

function cm.qjcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
end

function cm.qjval(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    return math.max(Duel.GetLP(tp)-8000,0)
end

function cm.tgtfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(cm.tgtfilter,tp,0x30,0,nil)>0 or Duel.IsPlayerCanDraw(tp,2) end
    Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,3))
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end

function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,Duel.GetLP(tp)-4000)
    Duel.BreakEffect()
    if not (Duel.GetMatchingGroupCount(cm.tgtfilter,tp,0x30,0,nil)>0) or Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))==1 then
        Duel.Draw(tp,2,REASON_EFFECT)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
        local g=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,0x30,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end

function cm.thcon3(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,m)~=0 and Duel.GetFlagEffect(1-tp,m)~=0
end

function cm.thop3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_CARD,0,m)
    Duel.Recover(tp,4000,REASON_EFFECT)
    c:RegisterFlagEffect(0,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,6))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m+2)
    e1:SetTarget(cm.thtg4)
    e1:SetOperation(cm.thop4)
    c:RegisterEffect(e1)
end

function cm.tgt4filter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

function cm.thtg4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(cm.tgt4filter,tp,0x01,0,nil)>0 end
    Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,6))
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.thop4(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.tgt4filter,tp,0x01,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end